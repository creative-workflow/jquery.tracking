# see: developers.google.com/analytics/devguides/collection/analyticsjs/events

class @JqueryTrackingFacebookAdapter
  constructor:(@options) ->

  trackEvent: (category, action, label, value) ->
    return unless fbq?
    fbq('track', 'ViewContent', {
      content_type: action
      content_name: label
      content_category: category
      value: value
    })

  trackClick: (source) ->
    return unless fbq?
    fbq('track', 'ViewContent', {
      content_type: 'source'
    })

  trackConversion: () ->
    return unless $.tracking.channel == 'fb'
    console.log '!!!FB tracked'
    return unless fbq?
    fbq('track', 'Lead')
