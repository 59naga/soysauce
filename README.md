# Soysauce [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Pretty sauceLabs browser matrix widget

[![Sauce Test Status][sauce-image]][sauce]

## Quick usage

__Can generate widgets for sessions.__

__http__://soysauce.berabou.me/u/`saucelabs_username`/`session_name`.svg

Example
* http://soysauce.berabou.me/u/59798/json-ml.svg
  
  ![](http://soysauce.berabou.me/u/59798/json-ml.svg?branch=master)

* http://soysauce.berabou.me/u/59798/object-parser.svg
  
  ![](http://soysauce.berabou.me/u/59798/object-parser.svg?branch=master)

* http://soysauce.berabou.me/u/59798/pixel.svg
  
  ![](http://soysauce.berabou.me/u/59798/pixel.svg?branch=master)

> Requirement allowed access at https://saucelabs.com/rest/v1/my_awesome_username/jobs

# Installation
```bash
$ npm install soysauce --global
$ soysauce -V
# 0.1.0
```

## Use SauceLabs REST API
```bash
$ soysauce "https://saucelabs.com/rest/v1/my_awesome_username/jobs?name=job_session_name&full=true&limit=50"
# <svg version="1.1" ...>
#   <rect x="0" y="0" width="460" height="16" fill="#232D34" />
#   <g class="h1 iphone">...</g>
#   <g class="ul">
#     <g class="li mac">...</g>
#   </g>
# </svg>
```

> https://docs.saucelabs.com/reference/rest-api/#full-jobs

## Force reload cache of `camo.githubusercontent.com`
See: [Why do my images have strange URLs? - User Documentation](https://help.github.com/articles/why-do-my-images-have-strange-urls/)

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[sauce-image]: http://soysauce.berabou.me/u/59798/zuul-example.svg?branch=master
[sauce]: https://saucelabs.com/u/59798
[npm-image]:https://img.shields.io/npm/v/soysauce.svg?style=flat-square
[npm]: https://npmjs.org/package/soysauce
[travis-image]: http://img.shields.io/travis/59naga/soysauce.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/soysauce
[coveralls-image]: http://img.shields.io/coveralls/59naga/soysauce.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/soysauce?branch=master
