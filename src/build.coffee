# No Dependencies

# Public
class Build
  # Sort by 2015 Apr http://gs.statcounter.com/
  names:
    googlechrome: 'Chrome'
    iexplore: 'IE'
    firefox: 'Firefox'
    safari: 'Safari'
    opera: 'Opera'
    iphone: 'iPhone'
    ipad: 'iPad'
    android: 'Android'
  
  constructor: (@saucelabsName,statuses,icons,osIcons)->
    @name= @names[@saucelabsName]
    @icon= icons?[@saucelabsName]
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
        build.osIcon= osIcons?[build.os]

        @builds.push build

module.exports= Build