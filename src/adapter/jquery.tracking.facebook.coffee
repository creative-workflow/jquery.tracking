# see: https://developers.facebook.com/docs/ads-for-websites/pixel-events/v2.10

# $.tracking(
#   adapter: [
#       {
#         class: 'JqueryTrackingFacebookAdapter'
#         doNotTrackConversion: 'any'
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
    return if @options.doNotTrackConversion?

    if @options.channelName?
      return unless @controller.channel() == @options.channelName

    return unless @available()
    @_trackConversion()

  _trackConversion: ->
    window.fbq('track', 'Lead')

  available: =>
    unless window.fbq?
      @controller.debug('JqueryTrackingFacebookAdapter','"fbq" not loaded')

    window.fbq?
