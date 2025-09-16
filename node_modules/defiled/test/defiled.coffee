sinon = require('sinon')

describe 'defiled', ->
  afterEach -> process.cwd.restore()
  Given -> sinon.stub process, 'cwd'
  Given -> @subject = require '../lib/defiled'

  describe 'static methods', ->
    describe '.register', ->
      When -> @subject.register 'bigKebab', (word) -> word.replace(/\//g, '--')
      Then -> new @subject().transformers.bigKebab.should.be.a.Function()

    describe '.mixin', ->
      When -> @subject.mixin bigKebab: (word) -> word.replace(/\//g, '--')
      Then -> new @subject().transformers.bigKebab.should.be.a.Function()

  describe 'directory provided', ->
    Given -> @file = new @subject 'fruits/banana.js', '/foo/bar/baz'

    describe '#filename', ->
      Then -> @file.filename().should.eql 'banana.js'

    describe '#name', ->
      Then -> @file.name().should.eql 'banana'

    describe '#ext', ->
      Then -> @file.ext().should.eql '.js'

    describe '#path', ->
      Then -> @file.path().should.eql 'fruits'

    describe '#relative', ->
      context 'name', ->
        Then -> @file.relative({ name: false }).should.eql 'fruits'

      context 'ext', ->
        Then -> @file.relative({ ext: false }).should.eql 'fruits/banana'

      context 'no opts', ->
        Then -> @file.relative().should.eql 'fruits/banana.js'

      context 'as array', ->
        Then -> @file.relative({ array: true }).should.eql ['fruits', 'banana.js']

      context 'transform', ->
        context 'camelCase', ->
          Then -> @file.relative({ transform: 'camelCase' }).should.eql 'fruitsBanana'

        context 'dash', ->
          Then -> @file.relative({ transform: 'dash' }).should.eql 'fruits-banana'

        context 'underscore', ->
          Then -> @file.relative({ transform: 'underscore' }).should.eql 'fruits_banana'

        context 'human', ->
          Then -> @file.relative({ transform: 'human' }).should.eql 'Fruits banana'

        context 'title', ->
          Then -> @file.relative({ transform: 'title' }).should.eql 'Fruits Banana'

        context 'pipe', ->
          Then -> @file.relative({ transform: 'pipe' }).should.eql 'fruits|banana'
          
        context 'class', ->
          Then -> @file.relative({ transform: 'class' }).should.eql 'FruitsBanana'

        context 'lower', ->
          Then -> @file.relative({ transform: 'lower' }).should.eql 'fruitsbanana'
          
        context 'upper', ->
          Then -> @file.relative({ transform: 'upper' }).should.eql 'FRUITSBANANA'

        context 'dot', ->
          Then -> @file.relative({ transform: 'dot' }).should.eql 'fruits.banana'

        context 'custom transform via register', ->
          When -> @file.register('bigSnake', (word) -> word.replace(/\//g, '__'))
          Then ->
            @file.relative({ transform: 'bigSnake' }).should.eql 'fruits__banana'
            (typeof new @subject().transformers.bigSnake).should.eql 'undefined'

        context 'custom transform via mixin', ->
          When -> @file.mixin(bigSnake: (word) -> word.replace(/\//g, '__'))
          Then -> @file.relative({ transform: 'bigSnake' }).should.eql 'fruits__banana'

    describe '#absolute', ->
      context 'name', ->
        Then -> @file.absolute({ name: false }).should.eql '/foo/bar/baz/fruits'

      context 'ext', ->
        Then -> @file.absolute({ ext: false }).should.eql '/foo/bar/baz/fruits/banana'

      context 'no opts', ->
        Then -> @file.absolute().should.eql '/foo/bar/baz/fruits/banana.js'

      context 'as array', ->
        Then -> @file.absolute({ array: true }).should.eql ['foo', 'bar', 'baz', 'fruits', 'banana.js']

      context 'transform', ->
        context 'camelCase', ->
          Then -> @file.absolute({ transform: 'camel', name: false }).should.eql 'fooBarBazFruits'

        context 'dash', ->
          Then -> @file.absolute({ transform: 'kebab', name: false }).should.eql 'foo-bar-baz-fruits'

        context 'underscore', ->
          Then -> @file.absolute({ transform: 'snake', name: false }).should.eql 'foo_bar_baz_fruits'

        context 'human', ->
          Then -> @file.absolute({ transform: 'capitalize', name: false }).should.eql 'Foo bar baz fruits'

        context 'title', ->
          Then -> @file.absolute({ transform: 'bookCase', name: false }).should.eql 'Foo Bar Baz Fruits'

        context 'pipe', ->
          Then -> @file.absolute({ transform: 'pipe', name: false }).should.eql 'foo|bar|baz|fruits'
          
        context 'class', ->
          Then -> @file.absolute({ transform: 'class', name: false }).should.eql 'FooBarBazFruits'

        context 'lower', ->
          Then -> @file.absolute({ transform: 'lower', name: false }).should.eql 'foobarbazfruits'
          
        context 'upper', ->
          Then -> @file.absolute({ transform: 'upper', name: false }).should.eql 'FOOBARBAZFRUITS'

        context 'dot', ->
          Then -> @file.absolute({ transform: 'dot', name: false }).should.eql 'foo.bar.baz.fruits'

        context 'custom transform via register', ->
          When -> @file.register('bigSnake', (word) -> word.replace(/\//g, '__'))
          Then -> @file.absolute({ transform: 'bigSnake', name: false }).should.eql 'foo__bar__baz__fruits'

        context 'custom transform via mixin', ->
          When -> @file.mixin(bigSnake: (word) -> word.replace(/\//g, '__'))
          Then -> @file.absolute({ transform: 'bigSnake', name: false }).should.eql 'foo__bar__baz__fruits'

    describe '#parent', ->
      context 'no opts', ->
        Then -> @file.parent().should.eql '/foo/bar/baz'

      context 'as array', ->
        Then -> @file.parent({ array: true }).should.eql ['foo', 'bar', 'baz']

      context 'transform', ->
        context 'camelCase', ->
          Then -> @file.parent({ transform: 'camel' }).should.eql 'fooBarBaz'

        context 'dash', ->
          Then -> @file.parent({ transform: 'kebab' }).should.eql 'foo-bar-baz'

        context 'underscore', ->
          Then -> @file.parent({ transform: 'snake' }).should.eql 'foo_bar_baz'

        context 'human', ->
          Then -> @file.parent({ transform: 'capitalize' }).should.eql 'Foo bar baz'

        context 'title', ->
          Then -> @file.parent({ transform: 'bookCase' }).should.eql 'Foo Bar Baz'

        context 'pipe', ->
          Then -> @file.parent({ transform: 'pipe' }).should.eql 'foo|bar|baz'
          
        context 'class', ->
          Then -> @file.parent({ transform: 'class' }).should.eql 'FooBarBaz'

        context 'lower', ->
          Then -> @file.parent({ transform: 'lower' }).should.eql 'foobarbaz'
          
        context 'upper', ->
          Then -> @file.parent({ transform: 'upper' }).should.eql 'FOOBARBAZ'

        context 'dot', ->
          Then -> @file.parent({ transform: 'dot' }).should.eql 'foo.bar.baz'

        context 'custom transform via register', ->
          When -> @file.register('bigSnake', (word) -> word.replace(/\//g, '__'))
          Then -> @file.parent({ transform: 'bigSnake' }).should.eql 'foo__bar__baz'

        context 'custom transform via mixin', ->
          When -> @file.mixin(bigSnake: (word) -> word.replace(/\//g, '__'))
          Then -> @file.parent({ transform: 'bigSnake' }).should.eql 'foo__bar__baz'
          
  describe 'no directory provided', ->
    Given -> process.cwd.returns '/foo/bar/baz'
    Given -> @file = new @subject 'fruits/banana.js'

    describe '#filename', ->
      Then -> @file.filename().should.eql 'banana.js'

    describe '#name', ->
      Then -> @file.name().should.eql 'banana'

    describe '#ext', ->
      Then -> @file.ext().should.eql '.js'

    describe '#path', ->
      Then -> @file.path().should.eql 'fruits'

    describe '#relative', ->
      context 'name', ->
        Then -> @file.relative({ name: false }).should.eql 'fruits'

      context 'ext', ->
        Then -> @file.relative({ ext: false }).should.eql 'fruits/banana'

      context 'no opts', ->
        Then -> @file.relative().should.eql 'fruits/banana.js'

      context 'as array', ->
        Then -> @file.relative({ array: true }).should.eql ['fruits', 'banana.js']

      context 'transform', ->
        context 'camelCase', ->
          Then -> @file.relative({ transform: 'camelCase' }).should.eql 'fruitsBanana'

        context 'dash', ->
          Then -> @file.relative({ transform: 'dash' }).should.eql 'fruits-banana'

        context 'underscore', ->
          Then -> @file.relative({ transform: 'underscore' }).should.eql 'fruits_banana'

        context 'human', ->
          Then -> @file.relative({ transform: 'human' }).should.eql 'Fruits banana'

        context 'title', ->
          Then -> @file.relative({ transform: 'title' }).should.eql 'Fruits Banana'

        context 'pipe', ->
          Then -> @file.relative({ transform: 'pipe' }).should.eql 'fruits|banana'
          
        context 'class', ->
          Then -> @file.relative({ transform: 'class' }).should.eql 'FruitsBanana'

        context 'lower', ->
          Then -> @file.relative({ transform: 'lower' }).should.eql 'fruitsbanana'
          
        context 'upper', ->
          Then -> @file.relative({ transform: 'upper' }).should.eql 'FRUITSBANANA'

        context 'dot', ->
          Then -> @file.relative({ transform: 'dot' }).should.eql 'fruits.banana'

        context 'custom transform via register', ->
          When -> @file.register('bigSnake', (word) -> word.replace(/\//g, '__'))
          Then -> @file.relative({ transform: 'bigSnake' }).should.eql 'fruits__banana'

        context 'custom transform via mixin', ->
          When -> @file.mixin(bigSnake: (word) -> word.replace(/\//g, '__'))
          Then -> @file.relative({ transform: 'bigSnake' }).should.eql 'fruits__banana'

    describe '#absolute', ->
      context 'name', ->
        Then -> @file.absolute({ name: false }).should.eql '/foo/bar/baz/fruits'

      context 'ext', ->
        Then -> @file.absolute({ ext: false }).should.eql '/foo/bar/baz/fruits/banana'

      context 'no opts', ->
        Then -> @file.absolute().should.eql '/foo/bar/baz/fruits/banana.js'

      context 'as array', ->
        Then -> @file.absolute({ array: true }).should.eql ['foo', 'bar', 'baz', 'fruits', 'banana.js']

      context 'transform', ->
        context 'camelCase', ->
          Then -> @file.absolute({ transform: 'camel', name: false }).should.eql 'fooBarBazFruits'

        context 'dash', ->
          Then -> @file.absolute({ transform: 'kebab', name: false }).should.eql 'foo-bar-baz-fruits'

        context 'underscore', ->
          Then -> @file.absolute({ transform: 'snake', name: false }).should.eql 'foo_bar_baz_fruits'

        context 'human', ->
          Then -> @file.absolute({ transform: 'capitalize', name: false }).should.eql 'Foo bar baz fruits'

        context 'title', ->
          Then -> @file.absolute({ transform: 'bookCase', name: false }).should.eql 'Foo Bar Baz Fruits'

        context 'pipe', ->
          Then -> @file.absolute({ transform: 'pipe', name: false }).should.eql 'foo|bar|baz|fruits'
          
        context 'class', ->
          Then -> @file.absolute({ transform: 'class', name: false }).should.eql 'FooBarBazFruits'

        context 'lower', ->
          Then -> @file.absolute({ transform: 'lower', name: false }).should.eql 'foobarbazfruits'
          
        context 'upper', ->
          Then -> @file.absolute({ transform: 'upper', name: false }).should.eql 'FOOBARBAZFRUITS'

        context 'dot', ->
          Then -> @file.absolute({ transform: 'dot', name: false }).should.eql 'foo.bar.baz.fruits'

        context 'custom transform via register', ->
          When -> @file.register('bigSnake', (word) -> word.replace(/\//g, '__'))
          Then -> @file.absolute({ transform: 'bigSnake', name: false }).should.eql 'foo__bar__baz__fruits'

        context 'custom transform via mixin', ->
          When -> @file.mixin(bigSnake: (word) -> word.replace(/\//g, '__'))
          Then -> @file.absolute({ transform: 'bigSnake', name: false }).should.eql 'foo__bar__baz__fruits'

    describe '#parent', ->
      context 'no opts', ->
        Then -> @file.parent().should.eql '/foo/bar/baz'

      context 'as array', ->
        Then -> @file.parent({ array: true }).should.eql ['foo', 'bar', 'baz']

      context 'transform', ->
        context 'camelCase', ->
          Then -> @file.parent({ transform: 'camel' }).should.eql 'fooBarBaz'

        context 'dash', ->
          Then -> @file.parent({ transform: 'kebab' }).should.eql 'foo-bar-baz'

        context 'underscore', ->
          Then -> @file.parent({ transform: 'snake' }).should.eql 'foo_bar_baz'

        context 'human', ->
          Then -> @file.parent({ transform: 'capitalize' }).should.eql 'Foo bar baz'

        context 'title', ->
          Then -> @file.parent({ transform: 'bookCase' }).should.eql 'Foo Bar Baz'

        context 'pipe', ->
          Then -> @file.parent({ transform: 'pipe' }).should.eql 'foo|bar|baz'
          
        context 'class', ->
          Then -> @file.parent({ transform: 'class' }).should.eql 'FooBarBaz'

        context 'lower', ->
          Then -> @file.parent({ transform: 'lower' }).should.eql 'foobarbaz'
          
        context 'upper', ->
          Then -> @file.parent({ transform: 'upper' }).should.eql 'FOOBARBAZ'

        context 'dot', ->
          Then -> @file.parent({ transform: 'dot' }).should.eql 'foo.bar.baz'

        context 'custom transform via register', ->
          When -> @file.register('bigSnake', (word) -> word.replace(/\//g, '__'))
          Then -> @file.parent({ transform: 'bigSnake' }).should.eql 'foo__bar__baz'

        context 'custom transform via mixin', ->
          When -> @file.mixin(bigSnake: (word) -> word.replace(/\//g, '__'))
          Then -> @file.parent({ transform: 'bigSnake' }).should.eql 'foo__bar__baz'

  describe 'absolute file path', ->
    When -> @file = new @subject '/foo/bar/baz/banana.js', '/foo/bar'
    Then -> @file._file.should.eql 'baz/banana.js'
