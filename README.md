# Soysauce [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Pretty sauceLabs browser matrix widget

[![Sauce Test Status][sauce-image]][sauce]

# API

* [soysauce.berabou.me/u/`saucelabs_username`.svg](https://soysauce.berabou.me/u/59798.svg)
* [soysauce.berabou.me/u/`saucelabs_username`/`session_name`.svg](https://soysauce.berabou.me/u/59798/carrack.svg)

> Can be render if available `https://saucelabs.com/rest/v1/saucelabs_username/jobs`

## Provide widgets at your [Express4](http://expressjs.com/4x/api.html)

```bash
$ npm install express soysauce
$ node app.js
# Server running at http://localhost:59798/
```

`app.js`

```js
// Dependencies
var express= require('express');
var soysauce= require('soysauce');

// Setup express
var app= express();
app.use(soysauce.middleware({datauri:true}));
app.listen(59798,function(){
  console.log('Server running at http://localhost:59798/');
});
```

Can be render at:
* http://localhost:59798/`saucelabs_username`.svg
* http://localhost:59798/`saucelabs_username`/`session_name`.svg

## Middleware options

### `datauri`: default `true`

Replace the url of image to datauri for avoid [Mixed Content](https://developer.mozilla.org/en-US/docs/Security/MixedContent).

```js
// Not use datauri
app.use(soysauce.middleware());
app.listen(59798,function(){
  // ...
  // <image x="7" y="2" width="21" height="21" xlink:href="http://localhost:59798/59798/chrome_64x64.png" />
  // ...
});

// Use datauri
app.use(soysauce.middleware({datauri:true}));
app.listen(59799,function(){
  // ...
  // <image x="7" y="2" width="21" height="21" xlink:href=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAYjElEQVR4Ab2ZC5RdZZXnf/v7zn3XK6lUVV6VFyQQDRAgRGzAICDEKGLDIALSPhGlm/Ex3a09ziBjtw8UQdT2bfsYHEQcp0UcBGlQgmLkTSBASEJC3lVJveu+zvm+PeW996zcOmtCKoD+19q1v3uqslb+//3fe..." />
  // ...
});
```

### `cache`: default `true`

Cache the rendered svg.
Update the cache if the jobs have been added.

# CLI

## `soysauce url > widget.svg`

Render a &lt;svg&gt; to stdout If url is [jobs.json](https://docs.saucelabs.com/reference/rest-api/#jobs).

```bash
$ npm install soysauce --global
$ soysauce "https://saucelabs.com/rest/v1/59798/jobs?name=object-parser&full=true&limit=50" > widget.svg
```

# Relevant project
* [zuul](https://github.com/defunctzombie/zuul)
> multi-framework javascript browser testing

* [karma-saucelabs-launcher](https://github.com/59naga/karma-saucelabs-launcher)
> Launch any browser on SauceLabs at concurrency.

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[sauce-image]: http://soysauce.berabou.me/u/59798/hanzen.svg?branch=master
[sauce]: https://saucelabs.com/u/59798
[npm-image]:https://img.shields.io/npm/v/soysauce.svg?style=flat-square
[npm]: https://npmjs.org/package/soysauce
[travis-image]: http://img.shields.io/travis/59naga/soysauce.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/soysauce
[coveralls-image]: http://img.shields.io/coveralls/59naga/soysauce.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/soysauce?branch=master
