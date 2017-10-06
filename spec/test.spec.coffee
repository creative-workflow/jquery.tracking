
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

        it "doesnt calls console.log method", ->
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
