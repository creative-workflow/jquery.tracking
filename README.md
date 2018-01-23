# jquery.tracking [![Build Status](https://travis-ci.org/creative-workflow/jquery.tracking.svg?branch=master)](https://travis-ci.org/creative-workflow/jquery.tracking) [![Code Climate](https://codeclimate.com/github/creative-workflow/jquery.tracking/badges/gpa.svg)](https://codeclimate.com/github/creative-workflow/jquery.tracking)

This plugin helps to handle click and event tracking with google universal analytics ([Read more](developers.google.com/analytics/devguides/collection/analyticsjs/events)).

You can implement your own tracking adapter, look at the implementation for [Google Analytics](https://github.com/creative-workflow/jquery.tracking/blob/master/src/jquery.tracking.ganalytics.coffee).

This plugin uses [jquery.debug](https://github.com/creative-workflow/jquery.debug) so all tracking information can be easily seen in the javascript console.

The plugin supports bounce rate adjustment by sending an event in a given interval.

You can configure url parameters that should be stored in cookies and will be send on every page initialization even when the url parameters are not present. Special parameters for advertising channel and campaign are present.

## Installation
    bower install jquery.tracking

## Usage
### javascript
    $.tracking({
      trackBounceIntervalSeconds: 10,
      sessionLifeTimeDays: 1, //sync with google analytics session lifetime
      cookiePrefix:      'tracking_',
      cookiePath:        '.example.com',
      sourceParamName:   'src',
      campaignParamName: 'cmp',
      storageParams: {
        'src': 'organic', //source, default: organic
        'cmp': 'organic' //campaign, default: organic
      },
      adapter: [
        {
          class: 'JqueryTrackingGAnalyticsAdapter'
        }
      ]
    });

    $.tracking.click('my fancy link'); //sends a click event (category: button, action: click)

    $.tracking.event('category', 'action', 'label', 'value', track_only_one_time=false); //sends natural event

    $.tracking.conversion()

It also exposes the class `JQueryTracking` for manual instantiating.

### coffee script
    $.tracking
      trackBounceIntervalSeconds: 10
      sessionLifeTimeDays: 1
      cookiePrefix: 'tracking_'
      cookiePath: '.example.com'
      sourceParamName: 'src'
      campaignParamName: 'cmp'
      storageParams:
        'src': 'organic'
        'cmp': 'organic'
      adapter: [
        {
          class: 'JqueryTrackingGAnalyticsAdapter'
        }
      ]

    $.tracking.click('my fancy link') # sends a click event (category: button, action: click)

    $.tracking.event('category', 'action', 'label', 'value', track_only_one_time = false) # sends natural event

    $.tracking.conversion()

It also exposes the class `JQueryTracking` for manual instantiating and extending.

### Parameter
#### trackBounceIntervalSeconds: 10
Bounce rate adjustment by sending an event in a given interval.

Event
  * category: bounce rate adjustment
  * action: 10s | 20s | 30s | etc.

#### sessionLifeTimeDays: 1
Lifetime of the cookies. Should be in sync with google analytics [session time out](https://support.google.com/analytics/answer/2795871?hl=en).

#### cookiePrefix: 'tracking_'
Prefix for the cookies. The `src` storage param will be saved in a cookie named `tracking_src`.

#### cookiePath: '.example.com'
Path for the cookies. The trailing dot means that the cookies are valid for the domain and all subdomains.

#### sourceParamName: 'src'
Name of the source url parameter. You can read this value via `$.tracking.source`.

#### campaignParamName: 'cmp'
Name of the campaign url parameter. You can read this value via `$.tracking.campaign`.

#### storageParams:
Parameters that should be stored in cookies and will be send on every page initialization even when the url parameters are not present.

```
storageParams:
  'src': 'organic' # default organic, if no initial url param present
  'cmp': 'organic' # default organic, if no initial url param present
```
#### adapter
Tracking adapters that could be loaded. You can pass you own adapter by extending the configuration:

    adapter: [
      {
        class: 'JqueryTrackingGAnalyticsAdapter'
      },
      {
        class: 'JqueryTrackingGTagmanagerAdapter'
      },
      {
        class: 'JqueryTrackingFacebookAdapter'
        channelName: 'fb'                       # -> for trackConversion, should equal

      }
    ]

### Functions
#### $.tracking(configuration|null)
If a parameter is passed the configuration will be merged otherwise the configuration will be returned.

#### $.tracking.click(source)
Track a click event. The source can be used to indicate what link was clicked.

#### $.tracking.event(category, action, label, value)
Track an event. [Read more](developers.google.com/analytics/devguides/collection/analyticsjs/events)

#### $.tracking.channel(name)
Return the detected channel if name undefined, sets channel otherwise.

#### $.tracking.campaign(name)
Return the detected campaign if name undefined, sets campaign otherwise.

#### $.tracking.conversion()
Track an Conversion. For details look at the adapter:
  * [JqueryTrackingGAnalyticsAdapter](https://github.com/creative-workflow/jquery.tracking/blob/master/src/adapter/jquery.tracking.ganalytics.coffee)
  * [JqueryTrackingGTagmanagerAdapter](https://github.com/creative-workflow/jquery.tracking/blob/master/src/adapter/jquery.tracking.gtagmanager.coffee)
  * [JqueryTrackingFacebookAdapter](https://github.com/creative-workflow/jquery.tracking/blob/master/src/adapter/jquery.tracking.facebook.coffee)

#### $.tracking.triggerChannelEvent()
  Tracks an channel event based on stored channel:

  * category: advertising
  * action: channel
  * label: organic

#### $.tracking.triggerCampaignEvent()
  Tracks an campaign event based on stored campaign:

    * category: advertising
    * action: campaign
    * label: organic


### Variables
#### $.tracking.channel
Read the advertising channel.

#### $.tracking.campaign
Read the advertising campaign.

### Dependencies
  * [jquery](https://jquery.com)
  * [juery.debug](https://github.com/creative-workflow/jquery.debug)
  * [js-cookie](https://github.com/js-cookie/js-cookie)
  * [js-url](https://github.com/websanova/js-url)

### Resources
  * https://github.com/creative-workflow/jquery.tracking
  * https://travis-ci.org/creative-workflow/jquery.tracking
  * https://codeclimate.com/github/creative-workflow/jquery.tracking
  * http://bower.io/search/?q=jquery.tracking

### Development
#### Setup
  * `npm install`
  * `bower install`
  * `npm test`

#### Run tests and linter
  * `npm test`

#### Generate build
  * `npm run build`

### Authors

  [Tom Hanoldt](https://www.tomhanoldt.info)

## Changelog
### 1.0.7
  * make grunt-includes compatible with gulp-inlcude, no code affected

### 1.0.6
  * add `doNotTrackConversion` to facebook adapter

### 1.0.5
  * remove default adapter and storage params
  * rename `setChannel(name)` to `channel(name)`
  * rename `setCampaign(name)` to `campaign(name)`
  * add getter mthod for `channel()`
  * add getter mthod for `campaign()`

### 1.0.4
  * dont auto track channel and campaign
  * added `triggerChannelEvent` and `triggerCampaignEvent`

### 1.0.3
  * add new adapter JqueryTrackingFacebookAdapter and JqueryTrackingGTagmanagerAdapter
  * remove per trackBounceIntervalSeconds default
  * extend tests
  * more comments

### 1.0.2
  * fix: swap setChannel and setCampaign in bootstrap

### 1.0.1
  * initial

# Contributing

Check out the [Contributing Guidelines](CONTRIBUTING.md)
