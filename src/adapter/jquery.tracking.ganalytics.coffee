# see: developers.google.com/analytics/devguides/collection/analyticsjs/events

# $.tracking(
#   adapter: [
#       {
#         class: 'JqueryTrackingGAnalyticsAdapter'
#         doNotTrackConversion: 'any'
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

  trackConversion: (adapterData = {}) =>
    return if @options?.doNotTrackConversion

    @trackEvent(adapterData.eventCategory || 'advertising',
                adapterData.eventAction   || 'conversion',
                adapterData.eventLabel    || 'conversion',
                adapterData.eventValue    || 1)
