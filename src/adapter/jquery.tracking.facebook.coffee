# see: https://developers.facebook.com/docs/ads-for-websites/pixel-events/v2.10

# $.tracking(
#   adapter: [
#       {
#         class: 'JqueryTrackingFacebookAdapter'
#         channelName: 'fb'                       # -> for trackConversion
#       }
#     ]
#   )

class @JqueryTrackingFacebookAdapter
  constructor:(@options, @controller) ->

  trackEvent: (category, action, label, value) =>
    return unless @available()
    window.fbq('trackCustom', 'CustomEvent', {
      category: category
      action: action
      label: label
      value: value
    })

  trackClick: (source) =>
    @trackEvent('button', 'click', source)

  trackConversion: =>
    console.log @controller.channel, '==', @options.channelName
    return unless @controller.channel == @options.channelName
    return unless @available()
    @_trackConversion()

  _trackConversion: ->
    fbq('track', 'Lead')

  available: =>
    unless window.fbq?
      @controller.debug('JqueryTrackingFacebookAdapter','"fbq" not loaded')

    window.fbq?
