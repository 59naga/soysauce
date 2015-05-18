# No Dependencies

# Private
names=
  ipad: 'iPad'
  firefox: 'Firefox'
  iphone: 'iPhone'
  safari: 'Safari'
  googlechrome: 'Chrome'
  opera: 'Opera'
  iexplore: 'IE'
  android: 'Android'
  
icons=
  ipad: 'ipad_64x64.png'
  iphone: 'iphone_64x64.png'
  android: 'android_64x64.png'
  firefox: 'firefox_64x64.png'
  safari: 'safari_64x64.png'
  googlechrome: 'chrome_64x64.png'
  opera: 'opera_64x64.png'
  iexplore: 'ie_64x64.png'

osIcons=
  mac: 'mac_64x64.png'
  windows: 'windows_64x64.png'
  linux: 'linux_64x64.png'

# Public
class Browser
  constructor: (@saucelabsName,statuses)->
    @name= names[@saucelabsName]
    @icon= icons[@saucelabsName]
    @builds= []

    for status in statuses
      if status.browser is @saucelabsName
        build=
          id: status.id
          version: status.browser_short_version
          passed: status.passed
        build.getRaw= -> status

        [os,osVersion]= status.os.split ' '
        build.os= os.toLowerCase()
        build.osVersion= osVersion ? ''
        build.osIcon= osIcons[build.os]

        @builds.push build

module.exports= Browser