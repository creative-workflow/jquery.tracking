(function() {
  describe('jquery.tracking', function() {
    var $;
    $ = jQuery;
    describe("configuration", function() {
      describe("trackBounceIntervalSeconds", function() {
        return it('can be changed', function() {
          expect($.tracking().trackBounceIntervalSeconds).toBe(10);
          expect($.tracking().trackBounceIntervalSeconds).not.toBe(42);
          $.tracking({
            trackBounceIntervalSeconds: 42
          });
          return expect($.tracking().trackBounceIntervalSeconds).toBe(42);
        });
      });
      return describe("adapter", function() {
        it('has a default adapter', function() {
          return expect($.tracking().adapter).toContain({
            "class": 'JqueryTrackingGAnalyticsAdapter'
          });
        });
        return it('can be overridden', function() {
          expect($.tracking().adapter).toContain({
            "class": 'JqueryTrackingGAnalyticsAdapter'
          });
          $.tracking({
            adapter: [
              {
                "class": 'JqueryTrackingGTagmanagerAdapter'
              }
            ]
          });
          expect($.tracking().adapter).not.toContain({
            "class": 'JqueryTrackingGAnalyticsAdapter'
          });
          return expect($.tracking().adapter).toContain({
            "class": 'JqueryTrackingGTagmanagerAdapter'
          });
        });
      });
    });
    describe("adapter", function() {
      var adapter, i, len, ref, results;
      ref = ['JqueryTrackingGAnalyticsAdapter', 'JqueryTrackingGTagmanagerAdapter', 'JqueryTrackingFacebookAdapter'];
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        adapter = ref[i];
        results.push(describe("" + adapter, function() {
          adapter = new window[adapter](adapter, $.tracking.instance);
          it("has a trackClick method", function() {
            return expect(adapter.trackClick).not.toThrowError();
          });
          it("has a trackEvent method", function() {
            return expect(adapter.trackEvent).not.toThrowError();
          });
          return it("has a trackConversion method", function() {
            return expect(adapter.trackConversion).not.toThrowError();
          });
        }));
      }
      return results;
    });
    describe("not in debug mode", function() {
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
          it("calls adapters trackClick method", function() {
            $.debug(false);
            spyOn(oneAdapter, "trackClick").and.callThrough();
            $.tracking.click('category', 'action', 'label', 'value');
            return expect(oneAdapter.trackClick).toHaveBeenCalled();
          });
          return it("doesnt calls console.log method", function() {
            $.debug(false);
            spyOn(console, "log").and.callThrough();
            $.tracking.click('category', 'action', 'label', 'value');
            return expect(console.log).not.toHaveBeenCalled();
          });
        });
      });
    });
    return describe("in debug mode", function() {
      var oneAdapter;
      oneAdapter = $.tracking.adapter[0];
      return describe('click', function() {
        return it("calls console.log method", function() {
          $.debug(true);
          spyOn(console, "log").and.callThrough();
          $.tracking.click('category', 'action', 'label', 'value');
          return expect(console.log).toHaveBeenCalled();
        });
      });
    });
  });

}).call(this);
