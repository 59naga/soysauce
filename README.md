# Soysauce [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Create SauceLabs browser matrix widget

[![Sauce Test Status][sauce-image]][sauce]

## Installation
```bash
$ npm install soysauce --global

$ soysauce fetch
# <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="60" height="16" viewBox="0 0 60 16">
#   <rect x="0" y="0" width="60" height="16" fill="gray" />
#   <text x="4" y="11" fill="#dadada" font-size="7">Build unknown</text>
# </svg>
```

## CLI
```bash
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

### Use TravisCI log.txt

### Use Stdin-out
Create `widget.svg` by Pass [SauceLabs-job-statuses][1] to CLI

```bash
$ curl https://saucelabs.com/rest/v1/my_awesome_username/jobs?limit=10\&full=true | soysauce > widget.svg
```

[1]: https://docs.saucelabs.com/reference/rest-api/#full-jobs

### Use json
or Use `widget.json` like a below:

```json
[
  {
    "browser_short_version": "7.1",
    "video_url": "https://saucelabs.com/jobs/9088430fbfa54694b369ab63ad482891/video.flv",
    "creation_time": 1431859507,
    "custom-data": null,
    "browser_version": "7.1.",
    "owner": "my_awesome_username",
    "automation_backend": "appium",
    "id": "9088430fbfa54694b369ab63ad482891",
    "record_screenshots": true,
    "record_video": true,
    "build": null,
    "passed": false,
    "public": "public",
    "assigned_tunnel_id": null,
    "status": "complete",
    "log_url": "https://saucelabs.com/jobs/9088430fbfa54694b369ab63ad482891/selenium-server.log",
    "start_time": 1431859507,
    "proxied": false,
    "modification_time": 1431859582,
    "tags": [],
    "commands_not_successful": 3,
    "name": "my_repository_name",
    "selenium_version": null,
    "manual": false,
    "end_time": 1431859582,
    "error": null,
    "os": "Mac 10.9",
    "breakpointed": null,
    "browser": "iphone"
  }
]
```

```bash
# Output to filename
$ soysauce widget.json --output widget.svg

# Printout
$ soycause widget.json
#<svg version="1.1" ...>
#  <rect x="0" y="0" width="460" height="16" fill="#232D34" />
#  <g class="h1 firefox">...</g>
#  <g class="ul">...</g>
#  <g class="h1 googlechrome">...</g>
#  <g class="ul">...</g>
#  <g class="h1 iexplore">...</g>
#  <g class="ul">...</g>
#  <g class="h1 opera">...</g>
#  <g class="ul">...</g>
#  <g class="h1 safari">...</g>
#  <g class="ul">...</g>
#  <g class="h1 iphone">...</g>
#  <g class="ul">...</g>
#  <g class="h1 android">...</g>
#  <g class="ul">...</g>
#</svg>
```

### Use zuul
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
