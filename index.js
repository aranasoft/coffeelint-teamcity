function escapeTeamCityString(message) {
  if (message === null) {
    return '';
  }

  return message
    .replace(/\|/g, '||')
    .replace(/'/g, '|\'')
    .replace(/\n/g, '|n')
    .replace(/\r/g, '|r')
    .replace(/\u0085/g, '|x')
    .replace(/\u2028/g, '|l')
    .replace(/\u2029/g, '|p')
    .replace(/\[/g, '|[')
    .replace(/\]/g, '|]');
}

function prepareResults(results) {
  if ((results === null) || !(results.length > 0)) {
    return [];
  }

  return results.map(error => {
    const errorDetails = Object.keys(error).reduce((msg, key) => {
      if (['context', 'line', 'lineNumber'].indexOf(key) === -1) {
        return msg;
      }

      msg += `\n${key}: ${error[key]}`;
      return msg;
    }
    , '');

    return {
      name: `${error.name}: line ${error.lineNumber}`,
      message: error.message,
      detailed: `Message: ${error.message}\nDescription: ${error.description}${errorDetails}`
    };
  });
}

class TeamCityReporter {
  constructor(errorReport, options) {
    this.errorReport = errorReport;
    if (options === null) {
      options = {};
    }
  }

  publish() {
    this.print('progressStart \'Running CoffeeLint\'');

    for (const filename in this.errorReport.paths) {
      if ({}.hasOwnProperty.call(this.errorReport.paths, filename)) {
        const results = this.errorReport.paths[filename];
        this.reportPath(filename, results);
      }
    }

    return this.print('progressFinish \'Running CoffeeLint\'');
  }

  reportPath(path, results) {
    const errors = prepareResults(results);

    const suite = `CoffeeLint: ${path}`;
    this.print('testSuiteStarted',
      {name: suite});

    for (const error of [...errors]) {
      this.print('testStarted', {name: error.name});
      this.print('testFailed', error);
      this.print('testFinished', {name: error.name});
    }

    return this.print('testSuiteFinished',
      {name: suite});
  }

  print(message, attrs) {
    let log = message;
    if (typeof attrs === 'object') {
      log = Object.keys(attrs).reduce((l, key) => l + ' ' + key + '=\'' + escapeTeamCityString(attrs[key]) + '\''
        , log);
    }

    return console.log(`##teamcity[${log}]`);
  }
}

module.exports = TeamCityReporter;

