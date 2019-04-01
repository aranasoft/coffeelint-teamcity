/* eslint-env mocha */
const assert = require('assert');
const path = require('path');
const {spawn} = require('child_process');
const stripColor = require('strip-ansi');
const chai = require('chai');

const coffeelint = require.resolve('coffeelint/bin/coffeelint');

const {expect} = chai;
chai.use(require('chai-string'));

function run(app, args, cb) {
  const command = [app].concat(args);
  let stdout = '';
  let stderr = '';
  const node = process.execPath;
  const child = spawn(node, command);

  child.stderr.on('data', data => {
    stderr += data;
  });

  child.stdout.on('data', data => {
    stdout += data;
  });

  child.on('error', () => {
    cb();
  });

  child.on('close', code => {
    cb(null, code, stdout, stderr);
  });

  return child;
}

describe('running CoffeeLint with coffeelint-teamcity', () => {
  describe('against dirty coffee', () => {
    let output;

    before(done => {
      const args = ['--reporter', './', path.resolve('./test-fixtures/sampleBadFile.coffee')];

      run(coffeelint, args, (err, code, stdout) => {
        assert(!err, err);
        output = stripColor(stdout);
        done();
      });
    });

    it('should begin with progressStart', () => {
      return expect(output).to.startWith('##teamcity[progressStart \'Running CoffeeLint\']');
    });

    it('should contain testSuiteStarted', () => {
      return expect(output).to.contain('##teamcity[testSuiteStarted name=');
    });

    it('should contain testStarted', () => {
      return expect(output).to.contain('##teamcity[testStarted name=');
    });

    it('should contain testFailed', () => {
      return expect(output).to.contain('##teamcity[testFailed name=');
    });

    it('should contain testFinished', () => {
      return expect(output).to.contain('##teamcity[testFinished name=');
    });

    it('should contain testSuiteFinished', () => {
      return expect(output).to.contain('##teamcity[testSuiteFinished name=');
    });

    it('should end with progressFinish', () => {
      return expect(output).to.endWith('##teamcity[progressFinish \'Running CoffeeLint\']\n');
    });
  });

  describe('against clean coffee', () => {
    let output;

    before(done => {
      const args = ['--reporter', './', path.resolve('./test-fixtures/sampleCleanFile.coffee')];

      run(coffeelint, args, (err, code, stdout) => {
        assert(!err, err);
        output = stripColor(stdout);
        done();
      });
    });

    it('should begin with progressStart', () => {
      return expect(output).to.startWith('##teamcity[progressStart \'Running CoffeeLint\']');
    });

    it('should contain testSuiteStarted', () => {
      return expect(output).to.contain('##teamcity[testSuiteStarted name=');
    });

    it('should not contain testStarted', () => {
      return expect(output).to.not.contain('##teamcity[testStarted name=');
    });

    it('should not contain testFailed', () => {
      return expect(output).to.not.contain('##teamcity[testFailed name=');
    });

    it('should not contain testFinished', () => {
      return expect(output).to.not.contain('##teamcity[testFinished name=');
    });

    it('should contain testSuiteFinished', () => {
      return expect(output).to.contain('##teamcity[testSuiteFinished name=');
    });

    it('should end with progressFinish', () => {
      return expect(output).to.endWith('##teamcity[progressFinish \'Running CoffeeLint\']\n');
    });
  });
});

