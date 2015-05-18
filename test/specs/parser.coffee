# Dependencies
Soysauce= require '../../'
soysauce= new Soysauce

path= require 'path'

# Environment
fixturePath= path.join __dirname,'..','fixture.json'
TRAVIS_JOB_ID= 62892354

# Spec
describe 'Fetch SauceLabs Job statuses via TravisCI',->
  fixture= require fixturePath
  travisLog= null

  it 'Write json to TravisCI log.txt',->
    key= soysauce.getKey TRAVIS_JOB_ID
    log= soysauce.encrypt fixture,TRAVIS_JOB_ID

    expect(log).toBe key+JSON.stringify(fixture)+key

  it 'Fetch TravisCI log.txt',(done)->
    soysauce.fetchLog TRAVIS_JOB_ID,(error,log)->
      travisLog= log

      # Fake the stdout to TravisCI stdout
      travisLog+= soysauce.encrypt fixture,TRAVIS_JOB_ID

      expect(error).toBe null
      expect(log).toBeTruthy()
      done()

  it 'Parse json in TravisCI log.txt',->
    statuses= soysauce.parse travisLog,TRAVIS_JOB_ID
    expect(statuses).toEqual fixture
