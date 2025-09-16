sinon = require 'sinon'
proxyquire = require('proxyquire').noCallThru()

describe 'readutf', ->
  Given -> @fs =
    readFile: sinon.stub()
    readFileSync: sinon.stub()

  Given -> @subject = proxyquire '../../lib/readutf',
    fs: @fs

  describe '.readFile', ->
    When -> @subject.readFile 'file', 'cb'
    Then -> @fs.readFile.calledWith('file', { encoding: 'utf8' }, 'cb').should.be.true()

  describe '.readFileSync', ->
    When -> @subject.readFileSync 'file'
    Then -> @fs.readFileSync.calledWith('file', { encoding: 'utf8' }).should.be.true()
