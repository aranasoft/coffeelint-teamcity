# coffeelint-teamcity

[![Build Status][travis-image]][travis-url] [![NPM version][npm-image]][npm-url] [![Dependency Status][depstat-image]][depstat-url] [![devDependency Status][devdepstat-image]][devdepstat-url]

TeamCity Reporter for CoffeeLint. Formats output in TeamCity message
format for automatic consumption on TeamCity's Test tab.

## Install

```sh
$ npm install --save-dev coffeelint-teamcity
```
## Usage

### CoffeeLint CLI

> Requires `coffeelint@^1.4`

```
coffeelint --reporter node_modules/coffeelint-teamcity file.coffee
```

## License

[BSD-3-Clause](https://raw.githubusercontent.com/aranasoft/coffeelint-teamcity/master/LICENSE) © [Arana Software](http://www.aranasoft.com)

[npm-url]: https://npmjs.org/package/coffeelint-teamcity
[npm-image]: http://img.shields.io/npm/v/coffeelint-teamcity.svg

[travis-url]: http://travis-ci.org/aranasoft/coffeelint-teamcity
[travis-image]: https://travis-ci.org/aranasoft/coffeelint-teamcity.svg?branch=master

[depstat-url]: https://david-dm.org/aranasoft/coffeelint-teamcity
[depstat-image]: https://david-dm.org/aranasoft/coffeelint-teamcity.svg

[devdepstat-url]: https://david-dm.org/aranasoft/coffeelint-teamcity#info=devDependencies
[devdepstat-image]: https://david-dm.org/aranasoft/coffeelint-teamcity/dev-status.svg
