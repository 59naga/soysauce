# Dependencies
express= require 'express'
request= require 'request'

# Environment
API= 'https://saucelabs.com/rest/v1/'
VIEW= 'https://saucelabs.com/u/'

# Public
middleware= (soysauce)->
  router= express.Router()
  
  # API
  router.get '/u/:user/:repo.svg',(req,res,next)->
    req.sauce=
      limit: req.query.limit
      user: req.params.user
      repo: req.params.repo

    next()

  router.get '/u/:user.svg',(req,res,next)->
    req.sauce=
      limit: req.query.limit
      user: req.params.user
    
    next()

  # API -> Statuses
  router.use (req,res,next)->
    return next() unless req.sauce?

    # ex
    # $ curl "https://saucelabs.com/rest/v1/59798/jobs?name=object-parser&full=true&limit=50"

    limit= 50
    limit= ~~req.sauce.limit if req.sauce.limit < limit

    uri= API
    uri+= '/'+req.sauce.user
    uri+= '/jobs?full=true&limit='+limit
    uri+= '&name='+req.sauce.repo if req.sauce.repo?

    request uri,(error,response)->
      return res.status(500).end(error.message) if error
      
      req.statuses= JSON.parse response.body
      next()

  # Statuses -> Widget
  router.use (req,res,next)->
    return next() unless req.statuses?

    latest= {}
    latestId= null
    for status in req.statuses
      latestId?= status.build
      break if status.build isnt latestId

      latest[status.browser+status.browser_version]?= status

    req.widget= (status for version,status of latest)

    next()

  # Widget -> SVG (end)
  router.use (req,res,next)->
    return next() unless req.widget?

    {widget}= req
    lastModified= widget[0]?.start_time
    lastModified*= 1000 if lastModified?
    lastModified?= Date.now()

    svg= soysauce.render widget,datauri:yes
    res.set 'Pragma','no-cache'
    res.set 'Cache-Control','no-cache'
    res.set 'Content-Type','image/svg+xml'
    res.set 'Content-Length',svg.length
    res.set 'Last-Modified',new Date lastModified
    res.end svg

  # Otherwise
  router.get '/u/:user',(req,res)->
    res.redirect VIEW+req.params.user
  router.get '/u/:user/:repo',(req,res)->
    res.redirect VIEW+req.params.user
  router.use (req,res)->
    res.redirect 'https://github.com/59naga/soysauce/'

  router

module.exports= middleware