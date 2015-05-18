# Dependencies
Parser= require './parser'

express= require 'express'
mkdirp= require 'mkdirp'
request= require 'request'

path= require 'path'
request= require 'request'

# Environment
travis=
  gui:
    repos: 'https://travis-ci.org/'
  api:
    repos: 'https://api.travis-ci.org/repos/'

class Publisher extends Parser
  constructor: (@widgetDir)->
    @widgetDir?= path.join process.cwd(),'widgets'
    mkdirp.sync @widgetDir

    @middleware= express.Router()
    @middleware.get '/:user/:repo.svg',(req,res)=>
      slug= @getSlug req.params

      uri= travis.api.repos+ slug+ '/branches'
      request uri,(error,response)=>
        return res.status(500).end(error.message) if error

        repo= JSON.parse response.body
        latestJobId= repo.branches[0]?.job_ids[0]
        @fetchLog latestJobId,(error,log)=>
          return res.status(500).end(error.message) if error

          statuses= @parse log,latestJobId
          svg= @render statuses,standalone:yes
          res.set 'Content-Type','image/svg+xml'
          res.end svg
      
    @middleware.get '/:user/:repo',(req,res)=>
      slug= @getSlug req.params

      res.redirect travis.gui.repos+ slug

  getSlug: ({user,repo})->
    slug= user+'/'+repo

module.exports= Publisher