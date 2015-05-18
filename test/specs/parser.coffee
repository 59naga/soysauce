# Dependencies
Soysauce= require '../../'
soysauce= new Soysauce

path= require 'path'
fs= require 'fs'

# Environment
fixtureJson= path.join __dirname,'..','fixture.json'
fixtureLog= path.join __dirname,'..','fixture.log'
TRAVIS_JOB_ID= 62974455

# Spec
describe 'Fetch SauceLabs Job statuses via TravisCI',->
  fixture= require fixtureJson
  travisLog= null

  it 'Write json to TravisCI log.txt',->
    key= soysauce.getKey TRAVIS_JOB_ID
    log= soysauce.encrypt fixture,TRAVIS_JOB_ID

    expect(log).toBe key+JSON.stringify(fixture)+key

  it 'Fetch TravisCI log.txt',(done)->
    soysauce.fetchLog TRAVIS_JOB_ID,(error,log)->
      travisLog= log

      expect(error).toBe null
      expect(travisLog).toBeTruthy()
      done()

  it 'Parse json in TravisCI log.txt',->
    statuses= soysauce.parse travisLog,TRAVIS_JOB_ID
    
    expect(statuses).toEqual fixture

  it 'Parse json in TravisCI fixture.log',->
    log= fs.readFileSync(fixtureLog).toString()

    statuses= soysauce.parse log,TRAVIS_JOB_ID
    expect(statuses).toEqual fixture
