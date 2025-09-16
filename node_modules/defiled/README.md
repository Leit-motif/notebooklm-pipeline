[![Build Status](https://travis-ci.org/tandrewnichols/defiled.png)](https://travis-ci.org/tandrewnichols/defiled) [![downloads](http://img.shields.io/npm/dm/defiled.svg)](https://npmjs.org/package/defiled) [![npm](http://img.shields.io/npm/v/defiled.svg)](https://npmjs.org/package/defiled) [![Code Climate](https://codeclimate.com/github/tandrewnichols/defiled/badges/gpa.svg)](https://codeclimate.com/github/tandrewnichols/defiled) [![Test Coverage](https://codeclimate.com/github/tandrewnichols/defiled/badges/coverage.svg)](https://codeclimate.com/github/tandrewnichols/defiled) [![dependencies](https://david-dm.org/tandrewnichols/defiled.png)](https://david-dm.org/tandrewnichols/defiled)

# defiled

A class wrapper for interacting with file paths.

## Installation

`npm install --save defiled`

## Summary

Pass a file and (optionally) it's directory to `defiled` to get a instance of `File` back with some helper methods for parsing various parts of it. If you omit the directory, `process.cwd()` will be used instead.

### Example

```
var File = require('defiled');

var file = new File('foo/bar/banana.js', '/some/absolute/path');
var file2 = new File('baz/quux/apple.js'); // process.cwd() used as directory
```

## API

For these examples, suppose:

```
var file = new File('fruits/banana.js', '/foo/bar');
```

#### File#filename

Get file name and extension (just like `path.basename`).

```
file.filename(); // banana.js
```

#### File#name

Get the fie name without the extension.

```
file.name(); // banana
```

#### File#ext

Get the file extension. Aliased as `File#extention`

```
file.ext(); // .js
```

#### File#path

Get the relative part of the path up to the filename.

```
file.path(); // fruits
```

#### File#relative

Get the relative part of the path up to or including the name and extension. Aliased as `File#rel`.

```
file.relative(); // fruits/banana.js
file.relative({ ext: false }); // fruits/banana
file.relative({ name: false }); // fruits
```

Optionally, accepts an options object for controlling the return value (as shown above). Passing `{ name: false }` makes this function work exactly like `#path` above, but there are still times when you may want to call this instead. `#relative` accepts some other options to transform the return value. Pass `{ array: true }` to get the path parts split on "/".

```
file.relative({ array: true }); // ['fruits', 'banana.js']
file.relative({ array: true, name: false }); // ['fruits']
```

Additionally, you can pass `{ transform: 'name' }` to transform the path. The available transformers are:

* camel (or camelCase)
* dash (or kebab or kebabCase)
* underscore (or snake or snakeCase)
* title (or startCase or bookCase)
* human (or capitalize)
* pipe
* class
* lower
* upper
* dot

Also note that `{ ext: false }` is implied when using a transform. The extension will never be included in the transformed path.

```
file.relative({ transform: 'camel' }); // fruitsBanana
file.relative({ transform: 'dash' }); // fruits-banana
file.relative({ transform: 'snake' }); // fruits_banana
file.relative({ transform: 'title' }); // Fruits Banana
file.relative({ transform: 'human' }); // Fruit banana
file.relative({ transform: 'pipe' }); // fruits|banana
file.relative({ transform: 'class' }); // FruitsBanana
file.relative({ transform: 'lower' }); // fruitsbanana
file.relative({ transform: 'upper' }); // FRUITSBANANA
file.relative({ transform: 'dot' }); // fruits.banana
```

#### File#absolute

Get the absolute path up to or including the name and extension. Aliased as `File#abs`. This works just like `File#relative` (and accepts the same options) but prefixes the relative file with the directory passed in (or the cwd).

```
file.absolute(); // /foo/bar/fruits/banana.js
file.absolute({ ext: false }); // /foo/bar/fruits/banana
file.absolute({ name: false }); // /foo/bar/fruits
file.absolute({ array: true }); // ['foor', 'bar', 'fruits', 'banana.js'];
file.absolute({ transform: 'camelCase' }); fooBarFruitsBanana
```

#### File#parent

Get the absolute path up to but not including the relative path (i.e. the directory containing the relative path originally passed in). Aliased as `File#dir`. This works just like `File#relative` and `File#absolute` (and accepts the same options), but note that `{ ext: false }` and `{ name: false }` are meaningless, as those are already left off the path.

```
file.parent(); // /foo/bar
file.parent({ array: true }); // ['foo', 'bar']
file.parent({ transform: 'kebab' }); // 'foo-bar'
```

#### File#register

Register a custom transformer for this file instance. This takes a name and a function.

```
file.register('bigSnake', function(path) {
  return path.replace(/\W/g, '__');
});
file.relative({ transform: 'bigSnake' }); // 'fruits__banana'
```

#### File#mixin

Register multiple custom transformers for this file instance at the same time. This takes an object where the keys are the names of the transformers and the properties are the functions.

```
file.mixin({
  bigSnake: function(path) {
    return path.replace(/\W/g, '__');
  }
});
file.relative({ transform: 'bigSnake' }); // 'fruits__banana'
```

#### File.register

Just like `File#register`, but registers the transformer for all future file instances.

```
File.register('bigKebab', function(path) {
  return path.replace(/\W/g, '--');
});
new File('fruits/banana.js').relative({ transform: 'bigKebab' }); // fruits--banana
```

#### File.mixin

Just like `File#mixin`, but registers the transformer for all future file instances.

```
File.mixin({
  bigKebab: function(path) {
    return path.replace(/\W/g, '--');
  }
});
new File('fruits/banana.js').relative({ transform: 'bigKebab' }); // fruits--banana
```

#### Transformers

You do also have access to the transformers directly via `File.transformers.nameOfTransformer` (or on an instance via `file.transformers.nameOfTransformer`), which you can use to transform non-path strings as well.

```
File.transformers.camelCase('foo-bar-baz'); // fooBarBaz
File.transformers.pipe('foo-bar-baz'); // foo|bar|baz
```

## Contributing

Please see [the contribution guidelines](CONTRIBUTING.md).
