# Dependencies
soysauce= require '../src'

cheerio= require 'cheerio'

path= require 'path'

# Environment
fixturePath= path.join __dirname,'fixture.json'

# Spec
describe 'API',->
  describe '.render',->
    it 'Create',->
      fixture= require fixturePath

      svg= soysauce.render fixture
      $= cheerio.load svg

      expect($('g.li').length).toBe fixture.length

    it 'Create build unknown',->
      fixture= []

      svg= soysauce.render fixture
      $= cheerio.load svg

      expect($('text').text()).toBe 'Build unknown'

    it 'Create standalone',->
      fixture= require fixturePath

      svg= soysauce.render fixture,standalone:yes
      $= cheerio.load svg
      builds= $ 'g.li'
      hrefs= $('image').map(->$(this).attr 'xlink:href').get().toString()

      expect(builds.length).toBe fixture.length
      expect(hrefs).not.toMatch 'http:\/\/'
