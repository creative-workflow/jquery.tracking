# see: developers.google.com/analytics/devguides/collection/analyticsjs/events

class @JqueryTrackingGAnalyticsAdapter
  constructor:(@options) ->
    window.ga = window.ga || ->
      (ga.q = ga.q || []).push arguments

    window.ga.l = +new Date

  trackEvent: (category, action, label, value) ->
    window.ga('send', 'event', category, action, label, value)

  trackClick: (source) =>
    @trackEvent('button', 'click', source)
