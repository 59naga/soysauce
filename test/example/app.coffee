express= require 'express'
soysauce= require '../../'

options= {}
options.datauri= yes unless '--no-datauri' in process.argv
options.cache= false if '--no-cache' in process.argv

app= express()
app.use soysauce.middleware options
app.use (req,res)->
  res.redirect 'https://github.com/59naga/soysauce'
app.listen 59798,->
  console.log 'Server running at http://localhost:59798/'