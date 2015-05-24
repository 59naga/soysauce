express= require 'express'
soysauce= require './'

app= express()
app.use soysauce.middleware()
app.listen 59798