# jquery-cli2  [![Build Status](https://travis-ci.org/muchweb/jquery-cli2.svg)](https://travis-ci.org/muchweb/jquery-cli2) [![NPM version](https://badge.fury.io/js/jquery-cli2.svg)](http://badge.fury.io/js/jquery-cli2) ![License: GPLv3+](http://img.shields.io/badge/license-GPLv3%2B-brightgreen.svg)

Before using this, you should probably consider:

 - [pup](https://github.com/EricChiang/pup) - Parsing HTML at the command line
 - [Xidel](http://videlibri.sourceforge.net/xidel.html) - HTML/XML data extraction tool

## Installation

```
npm install --global jquery-cli2
```

## Usage

 - Counting items

```bash
cat categories.htm | jquery-cli2 --selector '#menu > ul > li > a' -c | paste -s -d+ | bc
```

```bash
cat categories.htm | jquery-cli2 --selector '#menu > ul > li > a' -c | wc -l
```

 - Parse file on disk

```bash
cat file.html | jquery-cli2 --text '#menu > li a'
```

 - cURL

```bash
# Find out when this package was last updated

curl https://www.npmjs.org/package/jquery-cli2 | jquery-cli2 --text 'table.metadata td' | grep 'ago'

# Output: '10 minutes ago'
```

 - Narrowing, using pipes

```bash
echo '<section><div><ul><li>testing</li></ul></div><section>' | jquery-cli2 --html div --no-trailing-line-break | jquery-cli2 --html ul --no-trailing-line-break
```

## :free: License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
