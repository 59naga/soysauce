# Dependencies
Soysauce= require '../../'
soysauce= new Soysauce

express= require 'express'
request= require 'request'
cheerio= require 'cheerio'

path= require 'path'
exec= (require 'child_process').exec

# Environment
PORT= 59798
URL= 'http://localhost:'+PORT+'/'
TRAVIS_JOB_ID= 62892354
widgetUrl= '59naga/zuul-reporter.svg'
clickedUrl= '59naga/zuul-reporter'

# Specs
describe 'Publish widget middleware',->
  serverDir= path.join process.cwd(),'widgets'
  server= null

  beforeAll (done)->
    app= express()
    app.use soysauce.middleware()
    
    server= app.listen PORT,->
      done()
  afterAll (done)->
    server.close()

    exec 'rm -rf '+serverDir,->
      done()

  it 'Get latest build widget',(done)->
    options= {}

    request URL+widgetUrl,options,(error,response)->
      $= cheerio.load response.body

      expect(error).toBe null
      expect(response.statusCode).toBe 200
      expect($('text').text()).toBe 'Build unknown'
      done()

  it 'Redirect to travis-ci',(done)->
    options=
      followRedirect: off

    request URL+clickedUrl,options,(error,response)->
      expect(error).toBe null
      expect(response.statusCode).toBe 302
      expect(response.headers.location).toBe 'https://travis-ci.org/'+clickedUrl
      done()