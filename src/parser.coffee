# Dependencies
Build= require './build'
Widget= require './widget'

request= require 'request'
travisFold= require 'travis-fold'

fs= require 'fs'
path= require 'path'

# Private
sauceLabsUrl= 'https://saucelabs.com/rest/v1/'
travisLogUrl= 'https://api.travis-ci.org/jobs/'

class Parser
  constructor: (@options={})->
    @options.standalone?= yes

  fetchBuild: (username,sessionId,callback)->
    request sauceLabsUrl+username+'/jobs/'+sessionId,(error,response)->
      callback error,response.body

  getKey: (id='UNKNOWN')->
    '=====TRAVIS_JOB_'+id+'_RESULT====='

  stringify: (statuses,id)->
    key= @getKey id

    if id
      widgetData= key+'\n'+(JSON.stringify statuses)+'\n'+key
    else
      widgetData= JSON.stringify statuses,null,2

    data= ''
    data+= travisFold.start 'soysauce' if id
    data+= widgetData
    data+= travisFold.end 'soysauce' if id
    data

  fetch: (id,callback)->
    request travisLogUrl+id+'/log.txt',(error,response)->
      callback error,response.body

  parse: (log,id)->
    statuses= []
    
    key= @getKey id

    begin= log.indexOf key
    begin+= key.length if begin > -1
    end= log.indexOf key,begin
    json= log.slice begin,end if begin > -1

    statuses= JSON.parse json if json?
    statuses

  render: (statuses)->
    columns= 0
    rows= 0

    widget= new Widget

    builds= []
    for name,full of Build::names
      browser= new Build name,statuses,widget.theme.icons,widget.theme.osIcons
      if browser.builds.length
        rows= browser.builds.length if rows< browser.builds.length
        builds.push browser
    columns= builds.length

    widget.svg columns,rows
    for browser,i in builds
      widget.svg.append widget.h1 browser,i
      widget.svg.append widget.ul browser,i

    if @options.standalone
      images= widget.document('image')
      for image in images
        imagePath= path.join widget.themePath,image.attribs['xlink:href']
        imageBase64= fs.readFileSync(imagePath).toString 'base64'
        datauri= 'data:image/png;base64,'+imageBase64

        image.attribs['xlink:href']= datauri

    widget.html()

module.exports= Parser