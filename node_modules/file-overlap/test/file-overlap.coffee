path = require 'path'

describe 'file-overlap', ->
  Given -> @subject = require '../lib/file-overlap'

  describe '.overlap', ->
    context 'absolute with relative', ->
      Then -> @subject.overlap('/foo/bar/baz', 'bar/baz/banana.js').should.eql 'bar/baz'

    context 'relative with absolute', ->
      Then -> @subject.overlap('bar/baz/banana.js', '/foo/bar/baz').should.eql 'bar/baz'
      
    context 'two absolute paths', ->
      Then -> @subject.overlap('/foo/bar/baz/banana.js', '/foo/bar/baz').should.eql '/foo/bar/baz'
      
    context 'two relative paths', ->
      Then -> @subject.overlap('foo/bar/baz/banana.js', 'bar/baz').should.eql 'bar/baz'

    context 'only a', ->
      Then -> @subject.overlap('foo/bar/baz/banana.js').should.eql ''

    context 'only b', ->
      Then -> @subject.overlap(undefined, 'foo/bar/baz/banana.js').should.eql ''

    context 'neither a nor b', ->
      Then -> @subject.overlap().should.eql ''
      
  describe '.difference', ->
    context 'absolute with relative', ->
      Then -> @subject.difference('/foo/bar/baz', 'bar/baz/banana.js').should.eql '/foo'

    context 'relative with absolute', ->
      Then -> @subject.difference('bar/baz/banana.js', '/foo/bar/baz').should.eql 'banana.js'
      
    context 'two absolute paths', ->
      Then -> @subject.difference('/foo/bar/baz/banana.js', '/foo/bar/baz').should.eql 'banana.js'
      
    context 'two relative paths', ->
      Then -> @subject.difference('foo/bar/baz/banana.js', 'bar/baz').should.eql 'foo'

    context 'only a', ->
      Then -> @subject.difference('foo/bar/baz/banana.js').should.eql 'foo/bar/baz/banana.js'

    context 'only b', ->
      Then -> @subject.difference(undefined, 'foo/bar/baz/banana.js').should.eql 'foo/bar/baz/banana.js'

    context 'neither a nor b', ->
      Then -> @subject.difference().should.eql ''

  describe '.differenceRight', ->
    context 'absolute with relative', ->
      Then -> @subject.differenceRight('/foo/bar/baz', 'bar/baz/banana.js').should.eql 'banana.js'

    context 'relative with absolute', ->
      Then -> @subject.differenceRight('bar/baz/banana.js', '/foo/bar/baz').should.eql '/foo'
      
    context 'two absolute paths', ->
      Then -> @subject.differenceRight('/foo/bar/baz/banana.js', '/foo/bar/baz').should.eql ''
      
    context 'two relative paths', ->
      Then -> @subject.differenceRight('foo/bar/baz/banana.js', 'bar/baz').should.eql ''

    context 'only a', ->
      Then -> @subject.difference('foo/bar/baz/banana.js').should.eql 'foo/bar/baz/banana.js'

    context 'only b', ->
      Then -> @subject.difference(undefined, 'foo/bar/baz/banana.js').should.eql 'foo/bar/baz/banana.js'

    context 'neither a nor b', ->
      Then -> @subject.difference().should.eql ''

  describe '.tail', ->
    context 'two absolute paths', ->
      Then -> @subject.tail('/foo/bar/baz/banana.js', '/foo/bar/baz').should.eql 'banana.js'

    context 'relative with absolute', ->
      Then -> @subject.tail('bar/baz/banana.js', '/foo/bar/baz').should.eql 'banana.js'

    context 'absolute with relative', ->
      Then -> @subject.tail('/foo/bar/baz/banana.js', 'bar/baz').should.eql 'banana.js'

    context 'two absolutes with non-unique path parts', ->
      Then -> @subject.tail('/foo/bar/baz/foo/banana.js', '/foo/bar/baz').should.eql 'foo/banana.js'

    context 'two relative paths', ->
      Then -> @subject.tail('bar/baz/banana.js', 'bar/baz').should.eql 'banana.js'

    context 'only a', ->
      Then -> @subject.tail('/foo/bar/baz/banana.js').should.eql '/foo/bar/baz/banana.js'

    context 'only b', ->
      Then -> @subject.tail(undefined, '/foo/bar/baz/banana.js').should.eql ''

    context 'neither a nor b', ->
      Then -> @subject.tail().should.eql ''
