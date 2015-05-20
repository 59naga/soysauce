# Soysauce [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Create SauceLabs browser matrix widget

[![Sauce Test Status][sauce-image]][sauce]

## Installation
```bash
$ npm install soysauce --global
$ soysauce -V
# 0.0.2-beta.1

$ soysauce widget 62974455
# <svg version="1.1" ...>
#   <rect x="0" y="0" width="460" height="16" fill="#232D34" />
#   <g class="h1 firefox">...</g>
#   <g class="ul">...</g>
#   <g class="h1 googlechrome">...</g>
#   <g class="ul">...</g>
#   <g class="h1 iexplore">...</g>
#   <g class="ul">...</g>
#   <g class="h1 opera">...</g>
#   <g class="ul">...</g>
#   <g class="h1 safari">...</g>
#   <g class="ul">...</g>
#   <g class="h1 iphone">...</g>
#   <g class="ul">...</g>
#   <g class="h1 android">...</g>
#   <g class="ul">...</g>
# </svg>
```

# CLI
```bash
$ soysauce --help
#  Usage: soysauce (widget.json / log.txt) [options]
#
#
#  Commands:
#
#    report <username> [job_id...]  Output widget.json
#    widget <log_id>                Output widget.svg via Travis-CI log.txt
#
#  Options:
#
#    -h, --help           output usage information
#    -V, --version        output the version number
#    -o, --output [path]  Output to [./widget].svg
```

## Use SauceLabs REST API
```bash
$ curl https://saucelabs.com/rest/v1/my_awesome_username/jobs?limit=10\&full=true | soysauce
# <svg version="1.1" ...>
#   <rect x="0" y="0" width="60" height="16" fill="gray" />
#   <text x="4" y="11" fill="#dadada" font-size="7">Build unknown</text>
# </svg>
```

> https://docs.saucelabs.com/reference/rest-api/#full-jobs

## Output widget.json
Type a `soysauce report my_awesome_username sauce_job_id sauce_job_id...`
```bash
$ soysauce report 59798 c3791dd7c71446b18b5f340a5eb85f96
# [{"browser_short_version":"7.1","video_url":"https://saucelabs.com/jobs/c3791dd7c71446b18b5f340a5eb85f96/video.flv","creation_time":1431931948,"custom-data":null,"browser_version":"7.1.","owner":"59798","automation_backend":"appium","id":"c3791dd7c71446b18b5f340a5eb85f96","record_screenshots":true,"record_video":true,"build":"21","passed":false,"public":"public","assigned_tunnel_id":null,"status":"complete","log_url":"https://saucelabs.com/jobs/c3791dd7c71446b18b5f340a5eb85f96/selenium-server.log","start_time":1431931948,"proxied":false,"modification_time":1431932018,"tags":[],"commands_not_successful":3,"name":"zuul-example","selenium_version":null,"manual":false,"end_time":1431932018,"error":null,"os":"Mac 10.9","breakpointed":null,"browser":"iphone"}]

$ soysauce report 59798 c3791dd7c71446b18b5f340a5eb85f96 | soysauce
# <svg version="1.1" ...>
#   <rect x="0" y="0" width="460" height="16" fill="#232D34" />
#   <g class="h1 iphone">...</g>
#   <g class="ul">
#     <g class="li mac">...</g>
#   </g>
# </svg>
```

## Use widget.json
```bash
# Output to filename
$ soysauce widget.json --output widget.svg

# Printout
$ soycause widget.json
# <svg version="1.1" ...>
#   <rect x="0" y="0" width="460" height="16" fill="#232D34" />
#   <g class="h1 firefox">...</g>
#   <g class="ul">...</g>
#   <g class="h1 googlechrome">...</g>
#   <g class="ul">...</g>
#   <g class="h1 iexplore">...</g>
#   <g class="ul">...</g>
#   <g class="h1 opera">...</g>
#   <g class="ul">...</g>
#   <g class="h1 safari">...</g>
#   <g class="ul">...</g>
#   <g class="h1 iphone">...</g>
#   <g class="ul">...</g>
#   <g class="h1 android">...</g>
#   <g class="ul">...</g>
# </svg>
```

## Use express4
```bash
$ npm install express soysauce --save
```
```js
var express= require('express');
var soysauce= require('soysauce');

var app= express();
app.use(soysauce.middleware());
app.listen(8000);
// Listen to http://localhost:8000
```
```bash
$ curl http://localhost:8000/59798/zuul-example.svg
# <svg version="1.1" ...>
#   <rect x="0" y="0" width="460" height="16" fill="#232D34" />
#   <g class="h1 firefox">...</g>
#   <g class="ul">...</g>
#   <g class="h1 googlechrome">...</g>
#   <g class="ul">...</g>
#   <g class="h1 iexplore">...</g>
#   <g class="ul">...</g>
#   <g class="h1 opera">...</g>
#   <g class="ul">...</g>
#   <g class="h1 safari">...</g>
#   <g class="ul">...</g>
#   <g class="h1 iphone">...</g>
#   <g class="ul">...</g>
#   <g class="h1 android">...</g>
#   <g class="ul">...</g>
# </svg>
```

### Un-offical widget
__http__://soysauce.berabou.me/ `travis_username` / `repository` .svg

> Requirement `$ soysauce report <username> [job_id...]` in TravisCI

e.g.:
* http://soysauce.berabou.me/59798/zuul-example.svg
* http://soysauce.berabou.me/59naga/history-json.svg

### Force reload cache of `camo.githubusercontent.com`
See: [Why do my images have strange URLs? - User Documentation](https://help.github.com/articles/why-do-my-images-have-strange-urls/)

## Use zuul
See:
* [Cloud testing - zuul Wiki](https://github.com/defunctzombie/zuul/wiki/Cloud-testing)
* [Travis ci - zuul Wiki](https://github.com/defunctzombie/zuul/wiki/Travis-ci)

### Example
Case: Jasmine2 cloud testing

`~/.zuulrc`
```yaml
sauce_username: my_awesome_username
sauce_key: 550e8400-e29b-41d4-a716-446655440000
```

`./test.js`
```js
describe('Hello',function(){
  var fixture;

  beforeAll(function(){
    expect(fixture).toBe(undefined);

    fixture= 'foo';
  });

  it('world',function(done){
    setTimeout(function(){
      expect(fixture).toBe('foo');

      fixture= null;
      done();
    },500);
  });

  afterAll(function(){
    expect(fixture).toBe(null);

    fixture= void 0;
  });
});
```

`./package.json`
```json
{
  "devDependencies": {
    "jasmine": "^2.3.1",
    "zuul": "git://github.com/59naga/zuul.git"
  },
  "scripts": {
    "test": "zuul test.js --report"
  }
}
```

`./.zuul.yaml`
```yaml
ui: jasmine2
browsers:
  - name: chrome
    version: latest
```

Run

```bash
$ npm test
# > zuul test.js --report

# - testing: chrome @ Windows 2012 R2: 42
# - queuing: <chrome 42 on Windows 2012 R2>
# - starting: <chrome 42 on Windows 2012 R2>
# - passed: <chrome 42 on Windows 2012 R2>
# all browsers passed
# skip 1 report cause TRAVIS_JOB_ID is null
```

### Demo
* https://github.com/59798/zuul-example
* https://github.com/59naga/history-json

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[sauce-image]: http://soysauce.berabou.me/59798/zuul-example.svg?master
[sauce]: https://saucelabs.com/u/59798
[npm-image]:https://img.shields.io/npm/v/soysauce.svg?style=flat-square
[npm]: https://npmjs.org/package/soysauce
[travis-image]: http://img.shields.io/travis/59naga/soysauce.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/soysauce
[coveralls-image]: http://img.shields.io/coveralls/59naga/soysauce.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/soysauce?branch=master
