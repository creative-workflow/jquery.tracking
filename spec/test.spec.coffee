
describe 'jquery.tracking', ->
  $ = jQuery

  it 'can be configured', ->
    expect($.tracking().trackBounceIntervalSeconds).toBe(10)

    expect($.tracking().trackBounceIntervalSeconds).not.toBe(42)

    $.tracking(
      trackBounceIntervalSeconds: 42
    )
    expect($.tracking().trackBounceIntervalSeconds).toBe(42)

    expect($.tracking().adapter).toContain(
      class: 'JqueryTrackingGAnalyticsAdapter'
    )


  describe "not in debug mode", ->
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

  describe "in debug mode", ->
    oneAdapter = $.tracking.adapter[0]

    describe 'event', ->
      it "doesnt calls adapters trackEvent method", ->
        $.debug(true)
        spyOn(oneAdapter, "trackEvent").and.callThrough()

        $.tracking.event('category', 'action', 'label', 'value')

        expect(oneAdapter.trackEvent).not.toHaveBeenCalled()

      describe 'click', ->
        it "doesnt calls adapters trackClick method", ->
          $.debug(true)
          spyOn(oneAdapter, "trackClick").and.callThrough()

          $.tracking.click('category', 'action', 'label', 'value')

          expect(oneAdapter.trackClick).not.toHaveBeenCalled()
