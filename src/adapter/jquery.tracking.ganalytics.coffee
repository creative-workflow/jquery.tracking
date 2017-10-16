# see: developers.google.com/analytics/devguides/collection/analyticsjs/events

# $.tracking(
#   adapter: [
#       {
#         class: 'JqueryTrackingGAnalyticsAdapter'
#       }
#     ]
#   )

class @JqueryTrackingGAnalyticsAdapter
  constructor:(@options, @controller) ->
    window.ga = window.ga || ->
      (ga.q = ga.q || []).push arguments

    window.ga.l = +new Date

  trackEvent: (category, action, label, value) ->
    window.ga('send', 'event', category, action, label, value)

  trackClick: (source) =>
    @trackEvent('button', 'click', source)

  trackConversion: () =>
    @trackEvent('advertising', 'conversion', 'conversion', 1)
