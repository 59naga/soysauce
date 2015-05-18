# Dependencies
cheerio= require 'cheerio'
htmlBeautify= (require 'js-beautify').html

# Private
padding= 5
paddingTotal= (length,pixel=1)->
  value= 0
  value+= pixel for i in [0...length]
  value

# Public
class Widget
  constructor: (@columns,@rows)->
    @document= cheerio.load '<svg/>',xmlMode:yes

    @columnSize= 60
    @rowSize= 16
    @width= @columnSize* @columns+ paddingTotal(@columns,padding)+padding
    @height= @rowSize* @rows+ @rowSize+ paddingTotal(@rows)

    @count= @columns*@rows
    background= '#232D34'
    if @count is 0
      background= 'gray'

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
    @svg

    rect= @document '<rect/>'
    rect.attr
      x: 0
      y: 0
      width: @width
      height: @rowSize
      fill: background
    @svg.append rect

    if @count is 0
      text= @document '<text/>'
      text.attr
        x: 3
        y: 11
        fill: '#dad2da'
        'font-size': 10
      text.text 'Build unknown'
      @svg.append text
  
  h1: (browser,i)->
    g= @document '<g/>'

    g.attr class:'h1 '+browser.saucelabsName

    width= @columnSize
    height= @rowSize
    dx= padding+ width*i + i*padding
    dy= 0

    rect= @document '<rect/>'
    rectFill= 'transparent'
    rect.attr
      x: 0+ dx
      y: 0+ dy
      width: width
      height: height
      fill: rectFill
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
      x: 18+ dx
      y: 12+ dy
      'font-size': 10
      fill: 'white'
    text.text browser.name
    g.append text

    g

  ul: (browser,i)->
    g= @document '<g/>'
    g.attr class:'ul'

    g.append @li build,i,j for build,j in browser.builds

    g

  li: (build,i=0,j=0)->
    g= @document '<g/>'
    g.attr class:'li '+build.os

    width= @columnSize
    height= @rowSize
    dx= padding+ width* i + i*padding
    dy= height+ height*j + j

    rect= @document '<rect/>'
    rectFill= 'limegreen'
    rectFill= 'lightcoral' unless build.passed
    rect.attr
      x: 0+ dx
      y: 0+ dy
      width: width
      height: height
      fill: rectFill
    g.append rect

    text= @document '<text/>'
    text.text build.version
    text.attr
      x:  4+ dx
      y: 12+ dy
      'font-size': 10
    g.append text

    image= @document '<image/>'
    image.attr
      x: 22+ dx
      y:  1+ dy
      width: height-2
      height: height-2
      'xlink:href': build.osIcon
    g.append image

    text= @document '<text/>'
    text.text build.osVersion
    text.attr
      x: 39+ dx
      y: 10+ dy
      'font-size': 6
      fill: 'white'
    g.append text

    g

  html: ->
    htmlBeautify @document.html(),indent_size:2

module.exports= Widget