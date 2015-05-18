# Dependencies
Soysauce= require '../../'
soysauce= new Soysauce

cheerio= require 'cheerio'

path= require 'path'
fs= require 'fs'

# Environment
fixturePath= path.join __dirname,'..','fixture.json'

# Spec
describe 'SauceLabs browser matrix widget',->
  it 'Create',->
    fixture= require fixturePath

    svg= soysauce.render fixture
    $= cheerio.load svg

    expect($('g.li').length).toBe fixture.length

  it 'Create unknown statuses',->
    fixture= require fixturePath

    svg= soysauce.render []
    $= cheerio.load svg

    expect($('text').text()).toBe 'Build unknown'

  it 'Create Standalone SVG',->
    fixture= require fixturePath

    svg= soysauce.render fixture,standalone:yes
    $= cheerio.load svg
    builds= $ 'g.li'
    hrefs= $('image').map(->$(this).attr 'xlink:href').get().toString()

    expect(builds.length).toBe fixture.length
    expect(hrefs).not.toMatch 'http:\/\/'
