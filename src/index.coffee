# Dependencies
Widget= require './widget'
Matrix= require './matrix'
middleware= require './middleware'
pkg= require '../package'

CommandFile= (require 'commander-file').CommandFile

path= require 'path'
fs= require 'fs'

mkdirp= require 'mkdirp'
cacheDir= path.resolve __dirname,'..','widgets'
_= require 'lodash'

# Public
class Soysauce extends CommandFile
  constructor: ->
    super

    @widget= new Widget

  # CLI
  parse: (argv)->
    @version pkg.version

    super argv
    .then (data)=>
      try
        statuses= JSON.parse data
      catch e
        statuses= []

      latest= {}
      latestId= null
      for status in statuses
        latestId?= status.build
        break if status.build isnt latestId

        latest[status.browser+status.browser_short_version]?= status

      widget= (status for version,status of latest)

      try
        process.stdout.write @render widget,datauri:yes
        process.exit 0
      catch
        console.error data
        process.exit 1

  # API
  render: (statuses,options={})->
    columns= 0
    rows= 0

    builds= []
    for name,full of Matrix::names
      browser= new Matrix name,statuses,@widget.theme.icons,@widget.theme.osIcons
      if browser.builds.length
        rows= browser.builds.length if rows< browser.builds.length
        builds.push browser
    columns= builds.length

    @widget.init columns,rows
    for browser,i in builds
      @widget.svg.append @widget.h1 browser,i
      @widget.svg.append @widget.ul browser,i

    if options.base
      images= @widget.document('image')
      for image in images
        image.attribs['xlink:href']= options.base+'/'+image.attribs['xlink:href']

      return @widget.html()

    if options.datauri
      images= @widget.document('image')
      for image in images
        imagePath= path.join @widget.themePath,image.attribs['xlink:href']
        imageBase64= fs.readFileSync(imagePath).toString 'base64'
        datauri= 'data:image/png;base64,'+imageBase64

        image.attribs['xlink:href']= datauri
      
      return @widget.html()

    @widget.html()

  readCache: (slug,time)->
    widgetPath= path.join cacheDir,_.kebabCase(slug)+'.json'

    try
      cache= JSON.parse fs.readFileSync widgetPath,'utf8'
      cache.svg if time <= cache.time
    catch
      null

  writeCache: (slug,time,svg)->
    widgetPath= path.join cacheDir,_.kebabCase(slug)+'.json'

    mkdirp.sync cacheDir
    fs.writeFileSync widgetPath,JSON.stringify {time,svg}

  middleware: ->
    middleware this

module.exports= new Soysauce
module.exports.Soysauce= Soysauce