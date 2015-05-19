# Dependencies
Parser= require './parser'

express= require 'express'
request= require 'request'

path= require 'path'
request= require 'request'

class Middleware extends Parser
  api: 'https://api.travis-ci.org/repos/'
  gui: 'https://travis-ci.org/'
  
  constructor: (@widgetDir)->
    super()
    
    @widgetDir?= path.join process.cwd(),'widgets'

    @middleware= express.Router()
    @middleware.get '/:id(\\d+)',(req,res)=>
      @widget req.params.id,(error,log)=>
        statuses= @parse log,req.params.id
        svg= @render statuses
        res.set 'Content-Type','image/svg+xml'
        res.end svg

    @middleware.get '/:user/:repo.svg',(req,res)=>
      slug= @getSlug req.params

      uri= @api+ slug+ '/branches'
      request uri,(error,response)=>
        return res.status(500).end(error.message) if error

        repo= JSON.parse response.body
        latestJobId= repo.branches[0]?.job_ids[0]
        @widget latestJobId,(error,log)=>
          return res.status(500).end(error.message) if error

          statuses= @parse log,latestJobId
          svg= @render statuses
          res.set 'Content-Type','image/svg+xml'
          res.end svg
      
    @middleware.get '/:user/:repo',(req,res)=>
      slug= @getSlug req.params

      res.redirect @gui+ slug

  getSlug: ({user,repo})->
    slug= user+'/'+repo

module.exports= Middleware