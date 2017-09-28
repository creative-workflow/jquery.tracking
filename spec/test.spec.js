(function() {
  describe('jquery.tracking', function() {
    var $;
    $ = jQuery;
    it('can be configured', function() {
      expect($.tracking().trackBounceIntervalSeconds).toBe(10);
      expect($.tracking().trackBounceIntervalSeconds).not.toBe(42);
      $.tracking({
        trackBounceIntervalSeconds: 42
      });
      expect($.tracking().trackBounceIntervalSeconds).toBe(42);
      return expect($.tracking().adapter).toContain({
        "class": 'JqueryTrackingGAnalyticsAdapter'
      });
    });
    return describe("not in debug mode", function() {
      var oneAdapter;
      oneAdapter = $.tracking.adapter[0];
      return describe('event', function() {
        it("calls adapters trackEvent method", function() {
          $.debug(false);
          spyOn(oneAdapter, "trackEvent").and.callThrough();
          $.tracking.event('category', 'action', 'label', 'value');
          return expect(oneAdapter.trackEvent).toHaveBeenCalled();
        });
        return describe('click', function() {
          return it("calls adapters trackClick method", function() {
            $.debug(false);
            spyOn(oneAdapter, "trackClick").and.callThrough();
            $.tracking.click('category', 'action', 'label', 'value');
            return expect(oneAdapter.trackClick).toHaveBeenCalled();
          });
        });
      });
    });
  });

}).call(this);
