# Dependencies
express= require 'express'
request= require 'request'
_= require 'lodash'

path= require 'path'

# Environment
API= 'https://saucelabs.com/rest/v1/'
VIEW= 'https://saucelabs.com/u/'

# Public
middleware= (soysauce,options={})->
  router= express.Router()

  # Default options
  options.datauri?= yes
  options.cache?= yes

  # API
  router.get '/:user/:repo.svg',(req,res,next)->
    req.sauce=
      limit: req.query.limit
      user: req.params.user
      repo: req.params.repo

    next()

  router.get '/:user.svg',(req,res,next)->
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

      latest[status.browser+status.browser_short_version]?= status

    req.widget= (status for version,status of latest)

    next()

  # Widget -> SVG (end)
  router.use (req,res,next)->
    return next() unless req.widget?

    {widget}= req

    lastModified= _.max _.pluck widget,'end_time'
    lastModified*= 1000 if lastModified?
    lastModified?= Date.now()

    slug= req.sauce.user
    slug+= '/'+req.sauce.repo if req.sauce.repo?

    unless options.datauri
      options.base= req.protocol+'://'+req.get('host')+(path.dirname req.originalUrl)

    svg= soysauce.readCache slug,lastModified if options.cache
    unless svg?
      svg= soysauce.render widget,options
      soysauce.writeCache slug,lastModified,svg if options.cache

    res.set 'Pragma','no-cache'
    res.set 'Cache-Control','no-cache'
    res.set 'Content-Type','image/svg+xml'
    res.set 'Content-Length',svg.length
    res.set 'Last-Modified',(new Date lastModified).toUTCString()
    res.set 'Expires',(new Date 0).toUTCString()
    res.end svg

  # Expose theme icons
  router.use express.static soysauce.widget.themePath
  router.use '/:user/',express.static soysauce.widget.themePath
  
  # Otherwise
  router.get '/:user',(req,res)->
    res.redirect VIEW+req.params.user
  router.get '/:user/:repo',(req,res)->
    res.redirect VIEW+req.params.user

  router

module.exports= middleware