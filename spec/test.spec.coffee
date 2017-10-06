
describe 'jquery.tracking', ->
  $ = jQuery

  describe "configuration", ->
    describe "trackBounceIntervalSeconds", ->
      it 'can be changed', ->
        expect($.tracking().trackBounceIntervalSeconds).toBe(undefined)

        expect($.tracking().trackBounceIntervalSeconds).not.toBe(42)

        $.tracking(
          trackBounceIntervalSeconds: 42
        )
        expect($.tracking().trackBounceIntervalSeconds).toBe(42)

    describe "adapter", ->
      it 'has a default adapter', ->
        expect($.tracking().adapter).toContain(
          class: 'JqueryTrackingGAnalyticsAdapter'
        )

      it 'can be overridden', ->
        expect($.tracking().adapter).toContain(
          class: 'JqueryTrackingGAnalyticsAdapter'
        )

        $.tracking(
          adapter: [
            {
              class: 'JqueryTrackingGTagmanagerAdapter'
            }
          ]
        )

        expect($.tracking().adapter).not.toContain(
          class: 'JqueryTrackingGAnalyticsAdapter'
        )

        expect($.tracking().adapter).toContain(
          class: 'JqueryTrackingGTagmanagerAdapter'
        )

  describe "adapter", ->
    for adapter in [
      'JqueryTrackingGAnalyticsAdapter'
      'JqueryTrackingGTagmanagerAdapter'
      'JqueryTrackingFacebookAdapter'
    ]
      describe "#{adapter}", ->
        adapter = new window[adapter](adapter, $.tracking.instance)

        it "has a trackClick method", ->
           expect(adapter.trackClick).not.toThrowError()

        it "has a trackEvent method", ->
           expect(adapter.trackEvent).not.toThrowError()

        it "has a trackConversion method", ->
           expect(adapter.trackConversion).not.toThrowError()

      describe "JqueryTrackingFacebookAdapter", ->
        describe "trackConversion", ->
          window['fbq'] = ->
            null
            
          adapter = new window['JqueryTrackingFacebookAdapter']({
            class: 'JqueryTrackingFacebookAdapter'
            channelName: 'fb'
          }, $.tracking.instance)

          it "doesnt call _trackConversion if channel is unequal fb", ->
            $.tracking.setChannel('not fb')

            spyOn(adapter, "_trackConversion").and.callThrough()
            adapter.trackConversion()
            expect(adapter._trackConversion).not.toHaveBeenCalled()

          it "calls _trackConversion if channel equals fb", ->
            $.tracking.setChannel('fb')

            spyOn(adapter, "_trackConversion").and.callThrough()
            adapter.trackConversion()
            expect(adapter._trackConversion).toHaveBeenCalled()

  describe "controller", ->
    describe "callAdapters", ->
      it "calls the trackConversion method on all adapter", ->
        options = $.tracking.instance.constructor.options
        options['adapter'] = [
          {
            class: 'JqueryTrackingGTagmanagerAdapter'
          },
          {
            class: 'JqueryTrackingFacebookAdapter'
            channelName: 'fb'
          }
        ]

        $.tracking(options) # set configuration

        spyOn($.tracking.instance.adapter[0], "trackConversion").and.callThrough()
        spyOn($.tracking.instance.adapter[1], "trackConversion").and.callThrough()

        $.tracking.conversion()

        expect($.tracking.instance.adapter[0].trackConversion).toHaveBeenCalled()
        expect($.tracking.instance.adapter[1].trackConversion).toHaveBeenCalled()


    describe "not in debug mode", ->
      $.tracking($.tracking.instance.constructor.options) # reset configuration
      oneAdapter = $.tracking.adapter[0]

      describe 'event', ->
        it "calls adapters trackEvent method", ->
          $.debug(false)
          spyOn(oneAdapter, "trackEvent").and.callThrough()

          $.tracking.event('category', 'action', 'label', 'value')

          expect(oneAdapter.trackEvent).toHaveBeenCalled()

      describe 'click', ->
        it "calls adapters trackClick method", ->
          $.debug(false)
          spyOn(oneAdapter, "trackClick").and.callThrough()

          $.tracking.click('category', 'action', 'label', 'value')

          expect(oneAdapter.trackClick).toHaveBeenCalled()

        it "doesnt call console.log method", ->
          $.debug(false)
          spyOn(console, "log").and.callThrough()

          $.tracking.click('category', 'action', 'label', 'value')

          expect(console.log).not.toHaveBeenCalled()

    describe "in debug mode", ->
      oneAdapter = $.tracking.adapter[0]

      describe 'click', ->
        it "calls console.log method", ->
          $.debug(true)
          spyOn(console, "log").and.callThrough()

          $.tracking.click('category', 'action', 'label', 'value')

          expect(console.log).toHaveBeenCalled()
