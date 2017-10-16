(function() {
  describe('jquery.tracking', function() {
    var $;
    $ = jQuery;
    $.tracking({
      sessionLifeTimeDays: 1,
      cookiePrefix: 'tracking_',
      cookiePath: '.example.com',
      sourceParamName: 'src',
      campaignParamName: 'cmp',
      storageParams: {
        'src': 'organic',
        'cmp': 'organic'
      },
      adapter: [
        {
          "class": 'JqueryTrackingGAnalyticsAdapter'
        }
      ]
    });
    describe("controller", function() {
      return describe("channel", function() {
        return it('is accessible', function() {
          return expect($.tracking.channel()).toBe('organic');
        });
      });
    });
    describe("configuration", function() {
      describe("trackBounceIntervalSeconds", function() {
        return it('can be changed', function() {
          expect($.tracking().trackBounceIntervalSeconds).toBe(void 0);
          expect($.tracking().trackBounceIntervalSeconds).not.toBe(42);
          $.tracking({
            trackBounceIntervalSeconds: 42
          });
          return expect($.tracking().trackBounceIntervalSeconds).toBe(42);
        });
      });
      return describe("adapter", function() {
        return it('can be overridden', function() {
          $.tracking({
            adapter: [
              {
                "class": 'JqueryTrackingGAnalyticsAdapter'
              }
            ]
          });
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
        describe("" + adapter, function() {
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
        });
        results.push(describe("JqueryTrackingFacebookAdapter", function() {
          return describe("trackConversion", function() {
            window['fbq'] = function() {
              return null;
            };
            adapter = new window['JqueryTrackingFacebookAdapter']({
              "class": 'JqueryTrackingFacebookAdapter',
              channelName: 'fb'
            }, $.tracking.instance);
            it("doesnt call _trackConversion if channel is unequal fb", function() {
              $.tracking.channel('not fb');
              spyOn(adapter, "_trackConversion").and.callThrough();
              adapter.trackConversion();
              return expect(adapter._trackConversion).not.toHaveBeenCalled();
            });
            return it("calls _trackConversion if channel equals fb", function() {
              $.tracking.channel('fb');
              spyOn(adapter, "_trackConversion").and.callThrough();
              adapter.trackConversion();
              return expect(adapter._trackConversion).toHaveBeenCalled();
            });
          });
        }));
      }
      return results;
    });
    return describe("controller", function() {
      describe("callAdapters", function() {
        return it("calls the trackConversion method on all adapter", function() {
          var options;
          options = {
            sessionLifeTimeDays: 1,
            cookiePrefix: 'tracking_',
            cookiePath: '.example.com',
            sourceParamName: 'src',
            campaignParamName: 'cmp',
            storageParams: {
              'src': 'organic',
              'cmp': 'organic'
            },
            adapter: [
              {
                "class": 'JqueryTrackingGTagmanagerAdapter'
              }, {
                "class": 'JqueryTrackingFacebookAdapter',
                channelName: 'fb'
              }
            ]
          };
          $.tracking(options);
          spyOn($.tracking.instance.adapter[0], "trackConversion").and.callThrough();
          spyOn($.tracking.instance.adapter[1], "trackConversion").and.callThrough();
          $.tracking.conversion();
          expect($.tracking.instance.adapter[0].trackConversion).toHaveBeenCalled();
          return expect($.tracking.instance.adapter[1].trackConversion).toHaveBeenCalled();
        });
      });
      describe("not in debug mode", function() {
        var oneAdapter, options;
        options = {
          sessionLifeTimeDays: 1,
          cookiePrefix: 'tracking_',
          cookiePath: '.example.com',
          sourceParamName: 'src',
          campaignParamName: 'cmp',
          storageParams: {
            'src': 'organic',
            'cmp': 'organic'
          },
          adapter: [
            {
              "class": 'JqueryTrackingGTagmanagerAdapter'
            }
          ]
        };
        $.tracking(options);
        oneAdapter = $.tracking.adapter[0];
        describe('event', function() {
          return it("calls adapters trackEvent method", function() {
            $.debug(false);
            spyOn(oneAdapter, "trackEvent").and.callThrough();
            $.tracking.event('category', 'action', 'label', 'value');
            return expect(oneAdapter.trackEvent).toHaveBeenCalled();
          });
        });
        return describe('click', function() {
          it("calls adapters trackClick method", function() {
            $.debug(false);
            spyOn(oneAdapter, "trackClick").and.callThrough();
            $.tracking.click('category', 'action', 'label', 'value');
            return expect(oneAdapter.trackClick).toHaveBeenCalled();
          });
          return it("doesnt call console.log method", function() {
            $.debug(false);
            spyOn(console, "log").and.callThrough();
            $.tracking.click('category', 'action', 'label', 'value');
            return expect(console.log).not.toHaveBeenCalled();
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
  });

}).call(this);
