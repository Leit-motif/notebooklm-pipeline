[![Build Status](https://travis-ci.org/tandrewnichols/readutf.png)](https://travis-ci.org/tandrewnichols/readutf) [![downloads](http://img.shields.io/npm/dm/readutf.svg)](https://npmjs.org/package/readutf) [![npm](http://img.shields.io/npm/v/readutf.svg)](https://npmjs.org/package/readutf) [![Code Climate](https://codeclimate.com/github/tandrewnichols/readutf/badges/gpa.svg)](https://codeclimate.com/github/tandrewnichols/readutf) [![Test Coverage](https://codeclimate.com/github/tandrewnichols/readutf/badges/coverage.svg)](https://codeclimate.com/github/tandrewnichols/readutf) [![dependencies](https://david-dm.org/tandrewnichols/readutf.png)](https://david-dm.org/tandrewnichols/readutf)

# readutf

A thin wrapper around fs.readFile that automatically sets the encoding to utf8 on your behest

## Installation

`npm install --save readutf`

## Summary

I typically forget that "utf8" is not the default encoding when reading in a file. This wrapper sets `{ encoding: 'utf8' }` on `fs.readFile` and `fs.readFileSync` so you can pass only a filename or filename and callback.

## Usage

```
var utf = require('readutf');
utf.readFile('./lib/filename.txt', function(err, contents) {
  // "contents" is a string
});
var contents = utf.readFileSync('./lib/other-thing.ext'); // Also a string
```

## Contributing

Please see [the contribution guidelines](CONTRIBUTING.md).
