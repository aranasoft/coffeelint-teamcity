escapeTeamCityString = (message) ->
  return '' unless message?
  return message
    .replace /\|/g, '||'
    .replace /\'/g, '|\''
    .replace /\n/g, '|n'
    .replace /\r/g, '|r'
    .replace /\u0085/g, '|x'
    .replace /\u2028/g, '|l'
    .replace /\u2029/g, '|p'
    .replace /\[/g, '|['
    .replace /\]/g, '|]'

prepareResults = (results) ->
  return [] unless results? and results.length > 0
  results.map (error) ->
    errorDetails = Object.keys(error).reduce (msg, key) ->
      return msg if ['context','line','lineNumber'].indexOf(key) is -1
      msg += '\n' + key + ': ' + error[key]
      return msg
    , ''

    name: error.name + ': line ' + error.lineNumber
    message: error.message
    detailed: 'Message: ' + error.message + '\nDescription: ' + error.description + errorDetails

module.exports = class TeamCityReporter
  constructor: (@error_report, options = {}) ->

  publish: ->
    @print 'progressStart \'Running CoffeeLint\''

    for filename, results of @error_report.paths
      @reportPath filename, results

    @print 'progressFinish \'Running CoffeeLint\''

  reportPath: (path, results) ->
    errors = prepareResults results

    suite = 'CoffeeLint: ' + path
    @print 'testSuiteStarted',
      name: suite

    for error in errors
      @print 'testStarted', name: error.name
      @print 'testFailed', error
      @print 'testFinished', name: error.name

    @print 'testSuiteFinished',
      name: suite


  print: (message, attrs) ->
    log = message
    if typeof attrs is 'object'
      log = Object.keys(attrs).reduce (l, key) ->
        l + ' ' + key + '=\'' + escapeTeamCityString(attrs[key]) + '\''
      , log
    console.log '##teamcity[' + log + ']'



