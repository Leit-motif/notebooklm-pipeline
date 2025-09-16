describe 'readutf', ->
  Given -> @subject = require '../../lib/readutf'

  describe '.readFile', ->
    When (done) -> @subject.readFile("#{__dirname}/fixtures/banana.js", (err, @contents) => done())
    Then -> @contents.should.eql "module.exports = \'banana\';\n"

  describe '.readFileSync', ->
    When -> @contents = @subject.readFileSync "#{__dirname}/fixtures/banana.js"
    Then -> @contents.should.eql "module.exports = \'banana\';\n"
