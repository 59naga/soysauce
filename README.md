# Soysauce [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Create SauceLabs browser matrix widget

[![Sauce Test Status][sauce-image]][sauce]

## Installation
```bash
$ npm install soysauce --global
$ soysauce -V
# 0.0.2-beta.1

$ soysauce fetch 62974455
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
#    fetch <log_id>                 Output widget.svg via Travis-CI log.txt
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

## Use zuul
[See example](https://github.com/59798/zuul-example)

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[sauce-image]: http://soysauce.berabou.me/59798/zuul-example.svg?
[sauce]: https://saucelabs.com/u/59798
[npm-image]:https://img.shields.io/npm/v/soysauce.svg?style=flat-square
[npm]: https://npmjs.org/package/soysauce
[travis-image]: http://img.shields.io/travis/59naga/soysauce.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/soysauce
[coveralls-image]: http://img.shields.io/coveralls/59naga/soysauce.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/soysauce?branch=master
