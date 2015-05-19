# Dependencies
Parser= require './parser'
Middleware= require './middleware'

Command= (require 'commander').Command
cli= new Command
cliVersion= (require '../package').version

Promise= require 'bluebird'
travisFold= require 'travis-fold'

path= require 'path'
fs= Promise.promisifyAll(require 'fs')

# Public
class Soysauce extends Parser
  cli: (argv)->
    cli.version cliVersion
    cli.usage '(widget.json / log.txt) [options]'
    cli.option '-o, --output [path]','Output to [./widget].svg'

    cli
      .command 'report <username> [job_id...]'
      .description 'Output widget.json by SauceLabs Job API'
      .action (username,sauceJobIds)=>
        @report username,sauceJobIds,process.env.TRAVIS_JOB_ID
        .then (data)->
          console.log data

    cli
      .command 'fetch [log_id]'
      .description 'Output widget.svg via Travis-CI log.txt'
      .action =>
        @fetch arguments...
        .then (svg)->
          console.log svg

    cli.parse argv

    # Command mode
    delay= 500
    delayId=
      setTimeout =>
        process.stdin.pause()

        return cli.help() if cli.args.length is 0
        return if 'report' in cli.rawArgs
        return if 'fetch' in cli.rawArgs

        dataPath= path.resolve process.cwd(),cli.args[0]
        try
          raw= fs.readFileSync(dataPath).toString()
          data= JSON.parse raw if dataPath.match /.json$/
          data= @parse raw unless dataPath.match /.json$/
        catch
          data= {}

        widget= @render data
        return @output(cli.output,widget) if cli.output
        return process.stdout.write widget
      ,delay

    # Stdin mode
    processData= ''
    process.stdin.resume()
    process.stdin.setEncoding 'utf8'
    process.stdin.on 'data',(chunk)->
      clearTimeout delayId

      processData+= chunk
    process.stdin.on 'end',=>
      statuses= JSON.parse processData
      widget= @render statuses

      process.stdout.write widget if @stdout
      process.exit 0

  report: (username,sauceJobIds,travisJobId)->
    promises=
      for id in sauceJobIds
        promise=
          Promise.resolve id
          .then (id)->
            new Promise (resolve,reject)->
              Parser::fetchBuild username,id,(error,status)->
                resolve JSON.parse status unless error
                reject error if error

    Promise.all promises
    .then (statuses)=>
      widgetData= super statuses,travisJobId

      data= ''
      data+= travisFold.start 'soysauce'
      data+= widgetData
      data+= travisFold.end 'soysauce'
      data

  fetch: (logId)->
    new Promise (resolve,reject)=>
      super logId,(error,raw)=>
        return reject error if error?

        try
          data= @parse raw,logId
        catch
          data= {}

        resolve @render data

  output: (fileName,file)->
    fileName= 'widget' if fileName is yes
    fileName+= '.svg' unless fileName.match /.svg$/
    filePath= path.resolve process.cwd(),fileName

    fs.writeFileAsync filePath,file

  middleware: ->
    middleware= new Middleware arguments...
    middleware.middleware

module.exports= Soysauce