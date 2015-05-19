# Dependencies
Build= require './build'
Widget= require './widget'

request= require 'request'

fs= require 'fs'
path= require 'path'

# Private
sauceLabsUrl= 'https://saucelabs.com/rest/v1/'
travisLogUrl= 'https://s3.amazonaws.com/archive.travis-ci.org/jobs/'

class Parser
  constructor: (@options={})->
    @options.fold?= yes
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
    data+= 'travis_fold:start:widget\n' if @options.fold
    data+= widgetData+'\n'
    data+= 'travis_fold:end:widget\n' if @options.fold
    data

  widget: (id,callback)->
    request travisLogUrl+id+'/log.txt',(error,response)->
      callback error,response.body,response.headers

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