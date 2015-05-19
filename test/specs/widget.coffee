# Dependencies
soysauce= require '../../'
soysauce.options.fold= no
soysauce.options.standalone= no

cheerio= require 'cheerio'

path= require 'path'
fs= require 'fs'

# Environment
fixturePath= path.join __dirname,'..','fixture.json'

# Spec
describe 'Widget: Browser matrix widget',->
  it 'Create',->
    fixture= require fixturePath

    svg= soysauce.render fixture
    $= cheerio.load svg

    expect($('g.li').length).toBe fixture.length

  it 'Create build unknown',->
    fixture= require fixturePath

    svg= soysauce.render []
    $= cheerio.load svg

    # fs.writeFileSync fixturePath.replace(/.json$/,'.svg'),svg

    expect($('text').text()).toBe 'Build unknown'

  it 'Create standalone',->
    fixture= require fixturePath

    svg= soysauce.render fixture,standalone:yes
    $= cheerio.load svg
    builds= $ 'g.li'
    hrefs= $('image').map(->$(this).attr 'xlink:href').get().toString()

    # fs.writeFileSync fixturePath.replace(/.json$/,'.svg'),svg

    expect(builds.length).toBe fixture.length
    expect(hrefs).not.toMatch 'http:\/\/'
