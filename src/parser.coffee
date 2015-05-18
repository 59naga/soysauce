# Dependencies
Browser= require './browser'
Widget= require './widget'

request= require 'request'

fs= require 'fs'
path= require 'path'

# Private
travisLogUrl= 'https://api.travis-ci.org/jobs/'
saucelabsNames= [
  'ipad'
  'firefox'
  'iphone'
  'safari'
  'googlechrome'
  'opera'
  'iexplore'
  'android'
]

class Parser
  iconPath: path.resolve __dirname,'..','icons'

  getKey: (id='UNKNOWN')->
    '=====TRAVIS_JOB_'+id+'_RESULT====='

  encrypt: (statuses,id)->
    key= @getKey id
    key+JSON.stringify(statuses)+key

  fetchLog: (id,callback)->
    request travisLogUrl+id+'/log.txt',(error,response)->
      callback error,response.body

  parse: (travisLog,id)->
    statuses= []
    
    key= @getKey id

    begin= travisLog.indexOf key
    begin+= key.length if begin > -1
    end= travisLog.indexOf key,begin
    json= travisLog.slice begin,end if begin > -1

    statuses= JSON.parse json if json?
    statuses

  render: (statuses,options={})->
    columns= 0
    rows= 0

    builds= []
    for name in saucelabsNames
      browser= new Browser name,statuses
      if browser.builds.length
        rows= browser.builds.length if rows< browser.builds.length
        builds.push browser
    columns= builds.length

    widget= new Widget columns,rows
    for browser,i in builds
      widget.svg.append widget.h1 browser,i
      widget.svg.append widget.ul browser,i

    if options.standalone
      images= widget.document('image')
      for image in images
        imagePath= path.join @iconPath,image.attribs['xlink:href']
        imageBase64= fs.readFileSync(imagePath).toString 'base64'
        datauri= 'data:image/png;base64,'+imageBase64

        image.attribs['xlink:href']= datauri

    widget.html()

module.exports= Parser