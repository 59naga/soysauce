# Dependencies
soysauce= require '../../'

express= require 'express'
request= require 'request'
cheerio= require 'cheerio'

path= require 'path'
exec= (require 'child_process').exec

# Environment
TRAVIS_JOB_ID= 62974455
PORT= 59798
URL= 'http://localhost:'+PORT+'/'
widgetUrl= '59naga/zuul-example.svg'
clickedUrl= '59naga/zuul-example'

# Specs
describe 'Travis log.txt parser middleware',->
  serverDir= path.join process.cwd(),'widgets'
  server= null

  beforeAll (done)->
    app= express()
    app.use soysauce.middleware()
    
    server= app.listen PORT,->
      done()
  afterAll ->
    server.close()

  it 'Get widget.svg',(done)->
    options= {}

    request URL+TRAVIS_JOB_ID,options,(error,response)->
      $= cheerio.load response.body

      expect(error).toBe null
      expect(response.statusCode).toBe 200
      expect(response.headers['content-type']).toBe 'image/svg+xml'
      expect($('text').text()).not.toBe 'Build unknown'
      done()

  it 'Get latest widget.svg',(done)->
    options= {}

    request URL+widgetUrl,options,(error,response)->
      $= cheerio.load response.body

      expect(error).toBe null
      expect(response.statusCode).toBe 200
      expect(response.headers['content-type']).toBe 'image/svg+xml'
      expect($('text').text()).toBe 'Build unknown'
      done()

  it 'Redirect to travis-ci.org',(done)->
    options=
      followRedirect: off

    request URL+clickedUrl,options,(error,response)->
      expect(error).toBe null
      expect(response.statusCode).toBe 302
      expect(response.headers.location).toBe 'https://travis-ci.org/'+clickedUrl
      done()