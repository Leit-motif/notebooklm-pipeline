[![Build Status](https://travis-ci.org/tandrewnichols/file-overlap.png)](https://travis-ci.org/tandrewnichols/file-overlap) [![downloads](http://img.shields.io/npm/dm/file-overlap.svg)](https://npmjs.org/package/file-overlap) [![npm](http://img.shields.io/npm/v/file-overlap.svg)](https://npmjs.org/package/file-overlap) [![Code Climate](https://codeclimate.com/github/tandrewnichols/file-overlap/badges/gpa.svg)](https://codeclimate.com/github/tandrewnichols/file-overlap) [![Test Coverage](https://codeclimate.com/github/tandrewnichols/file-overlap/badges/coverage.svg)](https://codeclimate.com/github/tandrewnichols/file-overlap) [![dependencies](https://david-dm.org/tandrewnichols/file-overlap.png)](https://david-dm.org/tandrewnichols/file-overlap) ![Size](https://img.shields.io/badge/size-550b-brightgreen.svg)

# file-overlap

Get the overlapping part of two file paths

## Installation

`npm install --save file-overlap`

## Summary

`file-overlap` provides utitlies for getting the overlap and difference of two paths.

## Usage

`.overlap` returns the path that two paths have in common.

`.difference` returns the path that the first argument has that the second doesn't.

`.differenceRight` returns the path that the second argument has the the first doesn't.

`.tail` returns the difference at the end of the first argument when compared to b.

```
var overlap = require('file-overlap');

console.log( overlap.overlap('/foo/bar/baz', 'bar/baz/banana.js') ); // 'bar/baz'
console.log( overlap.difference('/foo/bar/baz', 'bar/baz/banana.js') ); // '/foo'
console.log( overlap.differenceRight('/foo/bar/baz', 'bar/baz/banana.js') ); // 'banana.js'
console.log( overlap.tail('/foo/bar/baz/banana.js', '/foo/bar/baz') ); // 'banana.js'

// N.B. Tail does not work in reverse (right now).
console.log( overlap.tail('/foo/bar/baz', '/foo/bar/baz/banana.js') ); // '/foo/bar/baz' <- obviously not correct
```

### Browser

Serve `dist/file-overlap.js` or `dist/file-overlap.min.js` however you serve javascript, then access `window.fileOverlap`.

## Contributing

Please see [the contribution guidelines](CONTRIBUTING.md).
