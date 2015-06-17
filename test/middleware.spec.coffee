# Dependencies
soysauce= require '../src'

express= require 'express'
request= require 'request'
cheerio= require 'cheerio'

exec= (require 'child_process').exec

# Environment
USERNAME= 59798
SESSIONNAME= 'object-parser'
PORT= 8798
DOMAIN= 'http://localhost:'+PORT+'/'

# Specs
describe 'Middleware: convert json to widget.svg',->
  server= null
  beforeAll (done)->
    app= express()
    app.use soysauce.middleware()
    
    server= app.listen PORT,->
      done()
  afterAll (done)->
    server.close()

    exec 'rm -rf '+process.cwd()+'/widgets',done

  it 'Get widget.svg',(done)->
    uri= DOMAIN+USERNAME+'/'+SESSIONNAME+'.svg'
    options=
      followRedirect: off

    request uri,options,(error,response)->
      $= cheerio.load response.body

      expect(error).toBe null
      expect(response.statusCode).toBe 200
      expect(response.headers['pragma']).toBe 'no-cache'
      expect(response.headers['cache-control']).toBe 'no-cache'
      expect(response.headers['content-type']).toBe 'image/svg+xml'
      expect(response.headers['expires']).toBe 'Thu, 01 Jan 1970 00:00:00 GMT'
      expect($('text').text()).not.toBe 'Build unknown'
      done()
  
  it 'Get latest widget.svg',(done)->
    uri= DOMAIN+'59798/abigail.svg'
    options=
      followRedirect: off

    request uri,options,(error,response)->
      $= cheerio.load response.body

      expect(error).toBe null
      expect(response.statusCode).toBe 200
      expect(response.headers['pragma']).toBe 'no-cache'
      expect(response.headers['cache-control']).toBe 'no-cache'
      expect(response.headers['content-type']).toBe 'image/svg+xml'
      expect(response.headers['expires']).toBe 'Thu, 01 Jan 1970 00:00:00 GMT'
      expect($('text').text()).toBe 'Build unknown'
      done()

  it 'Redirect to opensauce user page',(done)->
    uri= DOMAIN+'59798/zuul-example'
    options=
      followRedirect: off

    request uri,options,(error,response)->
      {statusCode, headers}= response

      expect(error).toBe null
      expect(statusCode).toBe 302
      expect(headers.location).toBe 'https://saucelabs.com/u/59798'
      done()
