# Dependencies
Build= require './build'
Widget= require './widget'

request= require 'request'

fs= require 'fs'
path= require 'path'

# Public
class Parser
  sauceLabsUrl: 'https://saucelabs.com/rest/v1/'
  travisJobUrl: 'https://api.travis-ci.org/jobs/'
  amazonLogUrl: 'https://s3.amazonaws.com/archive.travis-ci.org/jobs/'

  fetchBuild: (username,sessionId,callback)->
    request @sauceLabsUrl+username+'/jobs/'+sessionId,(error,response)->
      callback error,response.body

  getKey: (travisJobId='UNKNOWN')->
    '=====TRAVIS_JOB_'+travisJobId+'_RESULT====='
  getPrefix: (travisJobId)->
    prefix= ''
    prefix+= 'travis_fold:start:widget\n'
    prefix+= @getKey(travisJobId)+'\n'
    prefix
  getSuffix: (travisJobId)->
    suffix= ''
    suffix+= @getKey(travisJobId)+'\n'
    suffix+= 'travis_fold:end:widget\n'
    suffix

  stringify: (statuses,travisJobId)->
    data= ''

    if travisJobId
      data+= @getPrefix travisJobId
      data+= (JSON.stringify statuses)+'\n'
      data+= @getSuffix travisJobId
    else
      data= JSON.stringify statuses,null,2

    data

  widget: (travisJobId,args...,callback)->
    url= @travisJobUrl+travisJobId+'/log'
    url= @amazonLogUrl+travisJobId+'/log.txt' if args[0]?.s3
    request url,(error,response)->
      callback error,response.body,response.headers

  parse: (log,travisJobId)->
    statuses= []
    
    key= @getKey travisJobId

    begin= log.indexOf key
    begin+= key.length if begin > -1
    end= log.indexOf key,begin
    json= log.slice begin,end if begin > -1

    statuses= JSON.parse json if json?
    statuses

  render: (statuses,options={})->
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

    if options.datauri
      images= widget.document('image')
      for image in images
        imagePath= path.join widget.themePath,image.attribs['xlink:href']
        imageBase64= fs.readFileSync(imagePath).toString 'base64'
        datauri= 'data:image/png;base64,'+imageBase64

        image.attribs['xlink:href']= datauri

    widget.html()

module.exports= Parser