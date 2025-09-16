describe 'transformers', ->
  Given -> @subject = require '../lib/transformers'

  describe 'camelCase', ->
    Then -> @subject.camelCase('foo/bar-baz').should.eql 'fooBarBaz'

  describe 'camel', ->
    Then -> @subject.camel('foo/bar-baz').should.eql 'fooBarBaz'

  describe 'dash', ->
    Then -> @subject.dash('foo/bar-baz').should.eql 'foo-bar-baz'

  describe 'kebab', ->
    Then -> @subject.kebab('foo/bar-baz').should.eql 'foo-bar-baz'

  describe 'kebabCase', ->
    Then -> @subject.kebabCase('foo/bar-baz').should.eql 'foo-bar-baz'

  describe 'underscore', ->
    Then -> @subject.underscore('foo/bar-baz').should.eql 'foo_bar_baz'

  describe 'snake', ->
    Then -> @subject.snake('foo/bar-baz').should.eql 'foo_bar_baz'

  describe 'snakeCase', ->
    Then -> @subject.snakeCase('foo/bar-baz').should.eql 'foo_bar_baz'

  describe 'title', ->
    Then -> @subject.title('foo/bar-baz').should.eql 'Foo Bar Baz'

  describe 'startCase', ->
    Then -> @subject.startCase('foo/bar-baz').should.eql 'Foo Bar Baz'

  describe 'bookCase', ->
    Then -> @subject.bookCase('foo/bar-baz').should.eql 'Foo Bar Baz'

  describe 'human', ->
    Then -> @subject.human('foo/bar-baz').should.eql 'Foo bar baz'

  describe 'capitalize', ->
    Then -> @subject.capitalize('foo/bar-baz').should.eql 'Foo bar baz'

  describe 'pipe', ->
    Then -> @subject.pipe('foo/bar-baz').should.eql 'foo|bar|baz'

  describe 'class', ->
    Then -> @subject.class('foo/bar-baz').should.eql 'FooBarBaz'

  describe 'lower', ->
    Then -> @subject.lower('foo/bar-baz').should.eql 'foobarbaz'

  describe 'upper', ->
    Then -> @subject.upper('foo/bar-baz').should.eql 'FOOBARBAZ'

  describe 'dot', ->
    Then -> @subject.dot('foo/bar-baz').should.eql 'foo.barBaz'
