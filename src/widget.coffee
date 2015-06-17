# Dependencies
cheerio= require 'cheerio'
htmlBeautify= (require 'js-beautify').html
YAML= require 'yamljs'

path= require 'path'

# Public
class Widget
  themePath: path.resolve __dirname,'..','themes','default'
  constructor: (themePath)->
    @themePath= themePath if themePath?
    @theme= YAML.load path.join @themePath,'theme.yaml'

  init: (@columns,@rows)->
    @document= cheerio.load '<svg/>',xmlMode:yes

    @columnSize= 84
    @rowSize= 25
    @padding= 5
    @width= @columnSize* @columns+ @paddingTotal(@columns,@padding)+@padding
    @height= @rowSize* @rows+ @rowSize+ @paddingTotal(@rows)

    @count= @columns*@rows
    background= @theme.build.background
    if @count is 0
      background= @theme.unknown.background

      @width= @columnSize
      @height= @rowSize

    @svg= @document 'svg'
    @svg.attr
      version: 1.1
      xmlns: 'http://www.w3.org/2000/svg'
      'xmlns:xlink': 'http://www.w3.org/1999/xlink'
      width: @width
      height: @height
      viewBox: "0 0 #{@width} #{@height}"

    @svg.attr 'font-family','Monaco'
    @svg

    # [BACKGROUND-COLOR]
    rect= @document '<rect/>'
    rect.attr class:'header'
    rect.attr
      x: 0
      y: 0
      width: @width
      height: @rowSize
      fill: background
    @svg.append rect

    # [Build unknown]
    if @count is 0

      @svg.attr 'width',(@svg.attr 'width')*2
      @svg.attr 'height',(@svg.attr 'height')*2

      text= @document '<text/>'
      text.attr
        x: 6
        y: 15
        fill: '#dadada'
        'font-size': 9
      text.text 'Build unknown'
      @svg.append text
  
  # [ICON Name]
  h1: (browser,i)->
    g= @document '<g/>'

    g.attr class:'h1 '+browser.saucelabsName

    width= @columnSize
    height= @rowSize
    dx= @padding+ width*i + i*@padding
    dy= 0

    # [Invisible] (for debug)
    rect= @document '<rect/>'
    rect.attr
      x: 0+ dx
      y: 0+ dy
      width: width
      height: height
      fill: 'transparent'
    g.append rect

    image= @document '<image/>'
    image.attr
      x: 2+ dx
      y: 2+ dy
      width: height- 2*2
      height: height- 2*2
      'xlink:href': browser.icon
    g.append image

    text= @document '<text/>'
    text.attr
      x: 28+ dx
      y: 16+ dy
      'font-size': 12
      fill: @theme.build.color
    text.text browser.name
    g.append text

    g

  # [Invisible]
  ul: (browser,i)->
    g= @document '<g/>'
    g.attr class:'ul'

    g.append @li build,i,j for build,j in browser.builds

    g

  # [Verison OSIcon OSVersion]
  li: (build,i=0,j=0)->
    summary= 'Passed' if build.passed is true
    summary= 'Failing' if build.passed is false
    summary= 'Unknown' unless build.passed?
    summary+= ' '+build.browser+build.version
    summary+= ' '+build.os+build.osVersion

    g= @document '<g/>'
    g.attr title: summary
    g.attr class: 'li '+build.os

    width= @columnSize
    height= @rowSize
    dx= @padding+ width* i + i*@padding
    dy= height+ height*j + j

    rect= @document '<rect/>'
    rectFill= @theme.passed.background if build.passed is yes
    rectFill= @theme.falling.background if build.passed is no
    rectFill?= @theme.unknown.background
    rect.attr
      x: 0+ dx
      y: 0+ dy
      width: width
      height: height
      fill: rectFill
    g.append rect

    text= @document '<text/>'
    text.text build.version.replace /^beta$/,'β'
    text.attr
      x:  8+ dx + @textAlignRight build.version,6
      y: 16+ dy
      'font-size': 10
    g.append text

    image= @document '<image/>'
    image.attr
      x: 27+ dx
      y:  0+ dy
      width: height-2
      height: height-2
      'xlink:href': build.osIcon
    g.append image

    text= @document '<text/>'
    text.text build.osVersion
    textFill= @theme.passed.color if build.passed is yes
    textFill= @theme.falling.color if build.passed is no
    textFill?= @theme.unknown.color
    text.attr
      x: 50+ dx + @textAlignRight build.osVersion,6
      y: 15+ dy
      'font-size': 10
      fill: textFill
    g.append text

    g

  paddingTotal: (length,pixel=1)->
    value= 0
    value+= pixel for i in [0...length]
    value

  textAlignRight: (str,em)->
    return em if str.length is 1
    return em if str.length is 4
    return 0

  html: ->
    htmlBeautify @document.html(),indent_size:2

module.exports= Widget