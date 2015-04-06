# coffeelint-teamcity

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
coffeelint --reporter node_modules/coffeelint-teamcity/lib/reporter.js file.coffee
```

## License

[BSD-3-Clause](https://raw.githubusercontent.com/aranasoft/coffeelint-teamcity/master/LICENSE) © [Arana Software](http://www.aranasoft.com)
