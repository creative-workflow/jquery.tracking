
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


  describe "not in debug mode", ->
    $.tracking($.tracking.constructor.options) # reset configuration
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
