
class @JqueryTrackingGHelper
  @getClientId = (callback, fallback = null) ->
    if typeof ga != 'undefined'
      ga( (tracker) ->
        callback(tracker.get('clientId'))
      )
    else
      callback(fallback)

  @doGclidMatching: (channel = 'paid_search') ->
    possibleValue = url("?gclid")
    if possibleValue
      $.tracking.channel(channel)
      $.tracking.campaign(possibleValue)
