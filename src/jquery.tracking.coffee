include "jquery.tracking.ganalytics.coffee"

class @JqueryTracking
  @options =
    trackBounceIntervalSeconds: 10
    sessionLifeTimeDays: 1 #sync with google analytics session lifetime
    cookiePrefix:      'tracking_'
    cookiePath:        '.example.com'
    sourceParamName:   'src'
    campaignParamName: 'cmp'
    storageParams:
      'src': 'organic' #source
      'cmp': 'organic' #campaign
    adapter: [
      {
        class: 'JqueryTrackingGAnalyticsAdapter'
      }
    ]

  constructor: (@options)->
    @adapter = []
    @memory   = []
    @channel  = ''
    @campaign = ''

    @config jQuery.extend(@options, @constructor.options)

    @loadAdapter()

    @storeParams()  # store channel and campaign params to cookie, first contact
    @restorParams() # load channel and campaign from cookie

    if @options.trackBounceIntervalSeconds
      @trackBounce(@options.trackBounceIntervalSeconds)

  config: (options) =>
    @options = jQuery.extend(@options, options) if options
    @options

  debug: (label, args...) ->
    jQuery.debug.log("jquery.tracking::#{label}", args...)

  loadAdapter: =>
    for adapter in @options.adapter
      if adapter.class of window
        @debug("loadAdapter", adapter.class)
        @adapter.push new window[adapter.class](adapter)

  trackBounce: (durationInSeconds)=>
    timerCalled = 0
    do poll = =>
      if timerCalled
        action = (timerCalled*durationInSeconds).toString()+'s'
        @event('adjust bounce rate', action)
      timerCalled++

      setTimeout(poll, 1000 * durationInSeconds)

  callAdapters: (method, args...) =>
    jQuery.each @adapter, (index, adapter) =>
      @debug("#{adapter.options.class}::#{method}", args...)
      adapter[method](args...) unless jQuery.debug()

  wasAllreadyTracked: (name, value) =>
    id in @memory

  remember: (id) =>
    @memory.push id

  event: (category, action, label, value, once) =>
    id = "#{category}.#{action}.#{label}.#{value}"

    return if once && @wasAllreadyTracked(id)

    @remember(id)

    @callAdapters('trackEvent', category, action, label, value)

  click: (source) =>
    @callAdapters('trackClick', source)

  setChannel: (name) =>
    @channel = name
    @event('advertising', 'channel', @channel)

  setCampaign: (name) =>
    @campaign = name
    @event('advertising', 'campaign', @campaign)

  storeParams: =>
    jQuery.each @options.storageParams, (param, fallback) =>
      possibleOldValue = Cookies.get("#{@options.cookiePrefix}#{param}")

      value = url("?#{param}") || possibleOldValue || fallback

      if possibleOldValue != value
        @debug("storeParam::#{@options.cookiePrefix}", "#{param}=#{value}")
        Cookies.set("#{@options.cookiePrefix}#{param}",
                    value,
                    {
                      path: @options.cookiePath,
                      expires: @options.sessionLifeTimeDays
                    })

  restorParams: =>
    jQuery.each @options.storageParams, (param, fallback) =>
      value = Cookies.get("#{@options.cookiePrefix}#{param}") || fallback
      if value
        switch param
          when @options.sourceParamName   then @setChannel(value)
          when @options.campaignParamName then @setCampaign(value)
          else @event('parameter', param, value)


if typeof jQuery != 'undefined'
  instance = new JqueryTracking()
  $        = jQuery
  $.extend tracking: (args...)->
    return instance.config() unless args.length

    instance.config(args[0])

  #for calling instance methods directly
  $.extend $.tracking, instance

  #for test stubbing we need the real instance, the real this
  $.tracking.instance = instance
