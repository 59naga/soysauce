# Dependencies
soysauce= require '../../'
Parser= require '../../src/parser'
parser= new Parser

fs= require 'fs'
path= require 'path'

_= require 'lodash'
express= require 'express'

# Environment
fixtureJson= path.join __dirname,'..','fixture.json'
TRAVIS_JOB_ID= 62974455

# Specs
describe 'API',->
  it 'has Parser methods',->
    expect(soysauce.constructor.__super__).toEqual parser.__proto__

  it 'Fetch widget.json',(done)->
    fixture= JSON.parse fs.readFileSync(fixtureJson).toString()
    fixtureIds= _.pluck fixture,'id'

    soysauce.report 59798,fixtureIds
    .then (statuses)->
      ids= _.pluck (JSON.parse statuses),'id'

      expect(ids.length).toBe fixtureIds.length
      expect(_.difference fixtureIds,ids).toEqual []
      done()

  it 'Fetch widget.svg via TravisCI',(done)->
    soysauce.options.standalone= off
    soysauce.fetch TRAVIS_JOB_ID
    .then (svg)->

      expect(svg).toBe svg
      done()

  it 'Output to relative path',(done)->
    relativePath= 'test/specs/../foo'
    absolutePath= path.resolve process.cwd(),relativePath

    soysauce.output relativePath,'bar'
    .then ->
      expect(fs.existsSync absolutePath+'.svg').toBe yes
      expect(->fs.unlinkSync absolutePath+'.svg').not.toThrow()

      done()

  it 'Return Travis log.txt parser middleware',->
    expect(soysauce.middleware().name).toBe express.Router().name
