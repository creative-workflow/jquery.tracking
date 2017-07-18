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
      }
    });

    $.tracking.click('my fancy link'); //sends a click event (category: button, action: click)

    $.tracking.event('category', 'action', 'label', 'value', track_only_one_time=false); //sends natural event

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

    $.tracking.click('my fancy link') # sends a click event (category: button, action: click)

    $.tracking.event('category', 'action', 'label', 'value', track_only_one_time = false) # sends natural event

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

Event on page initialization:
  * category: parameter
  * action: name of the parameter
  * label: value of the parameter

#### adapter
The tracking adapters that should be loaded. You can pass you own adapter by extending the configuration:

    adapter: [
      {
        class: 'JqueryTrackingGAnalyticsAdapter'
      }
    ]

### Functions
#### $.tracking(configuration|null)
If a parameter is passed the configuration will be merged otherwise the configuration will be returned.

#### $.tracking.click(source)
Track a click event. The source can be used to indicate what link was clicked.

#### $.tracking.event(category, action, label, value)
Track an event. [Read more](developers.google.com/analytics/devguides/collection/analyticsjs/events)

### Variables
#### $.tracking.channel
Read the advertising channel.

#### $.tracking.campaign
Read the advertising campaign.

### Dependencies
  * [jquery](https://jquery.com)
  * [jquery.debug](https://github.com/creative-workflow/jquery.debug)
  * [js-cookie](https://github.com/js-cookie/js-cookie)
  * [js-url](https://github.com/websanova/js-url)

### Resources
  * https://github.com/creative-workflow/jquery.tracking
  * https://travis-ci.org/creative-workflow/jquery.tracking
  * https://codeclimate.com/github/creative-workflow/jquery.tracking
  * http://bower.io/search/?q=jquery.tracking

### Authors

  [Tom Hanoldt](https://www.tomhanoldt.info)

# Contributing

Check out the [Contributing Guidelines](CONTRIBUTING.md)
