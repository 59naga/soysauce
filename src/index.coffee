# Dependencies
Widget= require './widget'
Matrix= require './matrix'
middleware= require './middleware'
pkg= require '../package'

CommandFile= (require 'commander-file').CommandFile

path= require 'path'
fs= require 'fs'

# Public
class Soysauce extends CommandFile
  # CLI
  parse: (argv)->
    @version pkg.version

    super argv
    .then (data)=>
      try 
        process.stdout.write @render JSON.parse data
        process.exit 0
      catch
        console.error data
        process.exit 1

  # API
  render: (statuses,options={})->
    columns= 0
    rows= 0

    widget= new Widget

    builds= []
    for name,full of Matrix::names
      browser= new Matrix name,statuses,widget.theme.icons,widget.theme.osIcons
      if browser.builds.length
        rows= browser.builds.length if rows< browser.builds.length
        builds.push browser
    columns= builds.length

    widget.svg columns,rows
    for browser,i in builds
      widget.svg.append widget.h1 browser,i
      widget.svg.append widget.ul browser,i

    if options.datauri
      images= widget.document('image')
      for image in images
        imagePath= path.join widget.themePath,image.attribs['xlink:href']
        imageBase64= fs.readFileSync(imagePath).toString 'base64'
        datauri= 'data:image/png;base64,'+imageBase64

        image.attribs['xlink:href']= datauri

    widget.html()

  middleware: ->
    middleware this

module.exports= new Soysauce
module.exports.Soysauce= Soysauce