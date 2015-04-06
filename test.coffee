require 'coffee-script/register'
assert = require 'assert'
path = require 'path'
{spawn, exec} = require 'child_process'

should = require 'should'

# The path to the CoffeeLint command line.
coffeelintPath = path.join('node_modules', '.bin', 'coffeelint')

execOptions =
    cwd: __dirname
# Run the coffeelint command line with the given
# args. Callback will be called with (error, stdout,
# stderr)
commandline = (args, callback) ->
    exec("#{coffeelintPath} #{args.join(" ")}", execOptions, callback)

describe 'running CoffeeLint with coffeelint-teamcity', ->
  output = null
  before (done)->
    testResult = (error, stdout, stderr) ->
      output = stdout
      done()

    args = [
      'sampleBadFile.coffee'
      '--reporter ./teamcity.coffee'
    ]
    commandline args,testResult

  it 'should begin with progressStart', ->
    output.should.startWith '##teamcity[progressStart \'Running CoffeeLint\']'

  it 'should end with progressFinish', ->
    output.should.endWith '##teamcity[progressFinish \'Running CoffeeLint\']\n'

