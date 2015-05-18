# Dependencies
Parser= require './parser'
Publisher= require './publisher'

Command= (require 'commander').Command

path= require 'path'
fs= require 'fs'

# Public
class Soysauce extends Parser
  cli: (argv)->
    command= new Command
    command.version (require '../package').version
    command.usage 'path/to/statuses.json [options]'
    command.option '-p, --print', 'Print to stdout widget SVG'
    command.option '-e, --export [path]', 'Write widget SVG to [widget.svg]'
    command.option '-s, --stdio', 'Stdin-out widget SVG'
    command.parse argv
    command.help() if not command.stdio and command.args.length is 0

    if command.stdio
      data= ''

      process.stdin.resume()
      process.stdin.setEncoding 'utf8'
      process.stdin.on 'data',(chunk)->
        data+= chunk
      process.stdin.on 'end',=>
        statuses= JSON.parse data
        svg= @render statuses,standalone:yes

        process.stdout.write svg
        process.exit 0

    else
      statusesPath= path.resolve process.cwd(),command.args[0]
      statuses= require statusesPath

      if command.print
        svg= @render statuses,standalone:yes

        process.stdout.write svg
        process.exit 0

      if command.export
        fileName= command.export
        fileName= 'widget.svg' if command.export is yes
        filePath= path.relative process.cwd(),fileName

        svg= @render statuses,standalone:yes
        fs.writeFileSync filePath,svg

        process.exit 0

      # Write for TravisCI log.txt
      process.stdout.write @encrypt statuses,process.env.TRAVIS_JOB_ID
      process.exit 0

  middleware: ->
    publisher= new Publisher arguments...
    publisher.middleware

module.exports= Soysauce