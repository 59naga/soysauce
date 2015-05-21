# Dependencies
soysauce= require '../../'

express= require 'express'
request= require 'request'
cheerio= require 'cheerio'

# Environment
TRAVIS_JOB_ID= 62974455
PORT= 59798

domain= 'http://localhost:'+PORT+'/'
# TODO Build Summary e.g: "10/10"

# Specs
describe 'Middleware: Travis log.txt parser',->
  server= null
  beforeAll (done)->
    app= express()
    app.use soysauce.middleware()
    
    server= app.listen PORT,->
      done()
  afterAll ->
    server.close()

  it 'Get widget.svg',(done)->
    uri= domain+TRAVIS_JOB_ID+'.svg'
    options=
      followRedirect: off

    request uri,options,(error,response)->
      $= cheerio.load response.body

      expect(error).toBe null
      expect(response.statusCode).toBe 200
      expect(response.headers['pragma']).toBe 'no-cache'
      expect(response.headers['cache-control']).toBe 'no-cache'
      expect(response.headers['content-type']).toBe 'image/svg+xml'
      expect($('text').text()).not.toBe 'Build unknown'
      done()

  it 'Get latest widget.svg',(done)->
    uri= domain+'59naga/abigail.svg'
    options=
      followRedirect: off

    request uri,options,(error,response)->
      $= cheerio.load response.body

      expect(error).toBe null
      expect(response.statusCode).toBe 200
      expect(response.headers['pragma']).toBe 'no-cache'
      expect(response.headers['cache-control']).toBe 'no-cache'
      expect(response.headers['content-type']).toBe 'image/svg+xml'
      expect($('text').text()).toBe 'Build unknown'
      done()

  it 'Redirect to travis-ci.org',(done)->
    uri= domain+'59naga/zuul-example'
    options=
      followRedirect: off

    request uri,options,(error,response)->
      {statusCode, headers}= response

      expect(error).toBe null
      expect(statusCode).toBe 302
      expect(headers.location).toBe 'https://travis-ci.org/59naga/zuul-example'
      done()