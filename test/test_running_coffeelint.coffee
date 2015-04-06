require 'coffee-script/register'
assert = require 'assert'
path = require 'path'
{spawn, exec} = require 'child_process'

should = require 'should'

cwd = path.join __dirname, '..'
# The path to the CoffeeLint command line.
coffeelintPath = path.join 'node_modules', '.bin', 'coffeelint'
# The path to our fixtures
fixturePath = path.join 'test', 'fixtures'
# The path to our reporter
reporterPath = path.join cwd, 'src', 'reporter.coffee'

execOptions =
    cwd: cwd
# Run the coffeelint command line with the given
# args. Callback will be called with (error, stdout,
# stderr)
commandline = (args, callback) ->
    exec("#{coffeelintPath} #{args.join(" ")}", execOptions, callback)

describe 'running CoffeeLint with coffeelint-teamcity', ->
  describe 'against dirty coffee', ->
    output = null
    before (done)->
      testResult = (error, stdout, stderr) ->
        output = stdout
        done()

      args = [
        path.join fixturePath, 'sampleBadFile.coffee'
        '--reporter ' + reporterPath
      ]
      commandline args,testResult

    it 'should begin with progressStart', ->
      output.should.startWith '##teamcity[progressStart \'Running CoffeeLint\']'

    it 'should contain testSuiteStarted', ->
      output.should.match /##teamcity\[testSuiteStarted name=/

    it 'should contain testStarted', ->
      output.should.match /##teamcity\[testStarted name=/

    it 'should contain testFailed', ->
      output.should.match /##teamcity\[testFailed name=/

    it 'should contain testFinished', ->
      output.should.match /##teamcity\[testFinished name=/

    it 'should contain testSuiteFinished', ->
      output.should.match /##teamcity\[testSuiteFinished name=/

    it 'should end with progressFinish', ->
      output.should.endWith '##teamcity[progressFinish \'Running CoffeeLint\']\n'

  describe 'against clean coffee', ->
    output = null
    before (done)->
      testResult = (error, stdout, stderr) ->
        output = stdout
        done()

      args = [
        path.join fixturePath, 'sampleCleanFile.coffee'
        '--reporter ' + reporterPath
      ]
      commandline args,testResult

    it 'should begin with progressStart', ->
      output.should.startWith '##teamcity[progressStart \'Running CoffeeLint\']'

    it 'should contain testSuiteStarted', ->
      output.should.match /##teamcity\[testSuiteStarted name=/

    it 'should not contain testStarted', ->
      output.should.not.match /##teamcity\[testStarted name=/

    it 'should not contain testFailed', ->
      output.should.not.match /##teamcity\[testFailed name=/

    it 'should not contain testFinished', ->
      output.should.not.match /##teamcity\[testFinished name=/

    it 'should contain testSuiteFinished', ->
      output.should.match /##teamcity\[testSuiteFinished name=/

    it 'should end with progressFinish', ->
      output.should.endWith '##teamcity[progressFinish \'Running CoffeeLint\']\n'

