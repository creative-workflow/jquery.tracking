# see: https://productforums.google.com/forum/#!topic/tag-manager/EdC7TVyaCMw
# https://zadroweb.com/gtm-data-layer-event-tracking-guide/

# $.tracking(
#   adapter: [
#       {
#         class: 'JqueryTrackingGTagmanagerAdapter'
#       }
#     ]
#   )

class @JqueryTrackingGTagmanagerAdapter
  constructor:(@options, @controller) ->
    window.dataLayer = window.dataLayer || []

  trackEvent: (category, action, label, value) ->
    window.dataLayer.push({
      'event': 'gaEvent'
      'eventCategory': category
      'eventAction': action
      'eventLabel': label
      'eventValue': value
    })

  trackClick: (source) =>
    @trackEvent('button', 'click', source)

  trackConversion: () =>
    @trackEvent('advertsing', 'conversion')
