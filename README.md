# Soysauce [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Create SauceLabs browser matrix widget for [Zuul](https://github.com/59naga/zuul)

## Installation
```bash
$ npm install soysauce --global
```

## CLI
```bash
#  Usage: soysauce path/to/statuses.json [options]
#
#  Options:
#
#    -h, --help           output usage information
#    -V, --version        output the version number
#    -p, --print          Print to stdout widget SVG
#    -e, --export [path]  Write widget SVG to [widget.svg]
#    -s, --stdio          Stdin-out widget SVG
```

### Use Stdin-out
Create `widget.svg` by Pass [SauceLabs-job-statuses][1] to CLI

```bash
$ curl https://saucelabs.com/rest/v1/my_awesome_username/jobs?limit=10\&full=true | soysauce --stdio > widget.svg
```

[1]: https://docs.saucelabs.com/reference/rest-api/#full-jobs

### Use json
or Use `statuses.json` like a below:

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
$ soysauce statuses.json --export widget.svg
```

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[npm-image]:https://img.shields.io/npm/v/zuul-reporter.svg?style=flat-square
[npm]: https://npmjs.org/package/zuul-reporter
[travis-image]: http://img.shields.io/travis/59naga/zuul-reporter.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/zuul-reporter
[coveralls-image]: http://img.shields.io/coveralls/59naga/zuul-reporter.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/zuul-reporter?branch=master