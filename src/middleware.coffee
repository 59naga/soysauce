# Dependencies
Parser= require './parser'

express= require 'express'
request= require 'request'

# Public
class Middleware extends Parser
  API: 'https://api.travis-ci.org/repos/'
  GUI: 'https://travis-ci.org/'
  
  constructor: ->
    super

    @middleware= express.Router()
    @middleware.use (req,res,next)->
      req.travis= {}
      req.travis.s3= req.query.s3?
      req.travis.cache= cacheDir if cacheDir?

      next()

    @middleware.get '/:jobId.svg',(req,res,next)->
      req.travis.jobId= req.params.jobId
      next()

    @middleware.get '/:user/:repo.svg',(req,res,next)=>
      slug= @getSlug req.params

      uri= @API+ slug+ '/branches'
      request uri,(error,response)->
        return res.status(500).end(error.message) if error

        repo= JSON.parse response.body
        req.travis.jobId= repo.branches[0]?.job_ids[0]
        next()

    # jobId parser
    @middleware.use (req,res,next)=>
      return next() unless req.travis.jobId?

      @widget req.travis.jobId, req.travis, (error,body,headers)->
        return res.status(500).end(error.message) if error

        req.travis.widgetId= req.travis.jobId
        req.travis.widget= {body,headers}
        next()

    # widget parser
    @middleware.use (req,res,next)=>
      return next() unless req.travis.widget?

      statuses= @parse req.travis.widget.body,req.travis.widgetId
      svg= @render statuses,datauri:yes
      res.set 'Pragma','no-cache'
      res.set 'Cache-Control','no-cache'
      res.set 'Content-Type','image/svg+xml'
      res.set 'Content-Length',svg.length
      res.set 'Last-Modified',req.travis.widget.headers['last-modified']
      res.end svg

    @middleware.get '/:user/:repo',(req,res)=>
      slug= @getSlug req.params

      res.redirect @GUI+ slug

    @middleware.use (req,res)->
      res.redirect 'https://github.com/59naga/soysauce/'

  getSlug: ({user,repo})->
    slug= user+'/'+repo

module.exports= Middleware