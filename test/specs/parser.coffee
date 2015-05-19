# Dependencies
Parser= require '../../src/parser'
parser= new Parser

path= require 'path'
fs= require 'fs'

# Environment
fixtureJson= path.join __dirname,'..','fixture.json'
fixtureLog= path.join __dirname,'..','fixture.txt'
TRAVIS_JOB_ID= 62974455

# Spec
describe 'Fetch SauceLabs Job statuses via TravisCI',->
  fixture= require fixtureJson
  travisLog= null

  it 'Write widget.json',->
    log= parser.stringify fixture

    expect(log).toBe JSON.stringify fixture,null,2

  it 'Write widget.json for log.txt',->
    key= parser.getKey TRAVIS_JOB_ID
    log= parser.stringify fixture,TRAVIS_JOB_ID

    expect(log).toBe key+'\n'+JSON.stringify(fixture)+'\n'+key

  it 'Fetch log.txt',(done)->
    parser.fetch TRAVIS_JOB_ID,(error,log)->
      travisLog= log

      expect(error).toBe null
      expect(travisLog).toBeTruthy()
      done()

  it 'Parse log.txt',->
    statuses= parser.parse travisLog,TRAVIS_JOB_ID
    
    expect(statuses).toEqual fixture

  it 'Parse fixture.txt',->
    log= fs.readFileSync(fixtureLog).toString()

    statuses= parser.parse log,TRAVIS_JOB_ID
    expect(statuses).toEqual fixture
