# Dependencies
Parser= require './parser'
Widget= require './widget'

express= require 'express'
request= require 'request'

path= require 'path'
request= require 'request'

class Middleware extends Parser
  api: 'https://api.travis-ci.org/repos/'
  gui: 'https://travis-ci.org/'
  
  constructor: ->
    super

    @middleware= express.Router()
    @middleware.use express.static new Widget().themePath
    @middleware.get '/:id(\\d+)',(req,res,next)=>
      @widget req.params.id,(error,body,headers)->
        return res.status(500).end(error.message) if error

        req.widgetId= req.params.id
        req.widget= {body,headers}
        next()

    @middleware.get '/:user/:repo.svg',(req,res,next)=>
      slug= @getSlug req.params

      uri= @api+ slug+ '/branches'
      request uri,(error,response)=>
        return res.status(500).end(error.message) if error

        repo= JSON.parse response.body
        latestJobId= repo.branches[0]?.job_ids[0]
        @widget latestJobId,(error,body,headers)->
          return res.status(500).end(error.message) if error

          req.widgetId= latestJobId
          req.widget= {body,headers}
          next()

    @middleware.use (req,res,next)=>
      return next() unless req.widget?

      statuses= @parse req.widget.body,req.widgetId
      svg= @render statuses
      res.set 'Pragma','no-cache'
      res.set 'Cache-Control','no-cache'
      res.set 'Content-Type','image/svg+xml'
      res.set 'Content-Length',svg.length
      res.set 'Last-Modified',req.widget.headers['last-modified']
      res.end svg

    @middleware.get '/:user/:repo',(req,res)=>
      slug= @getSlug req.params

      res.redirect @gui+ slug

    @middleware.use (req,res)->
      res.redirect 'https://github.com/59naga/soysauce/'

  getSlug: ({user,repo})->
    slug= user+'/'+repo

module.exports= Middleware