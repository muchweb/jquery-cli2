###*
	@module jquery-cli2
	@author muchweb
###

'use strict'

jsdom = require 'jsdom'
input = ''
program = require 'commander'
package_json = require '../package.json'

program
	.usage '[--text \'selector\']'
	.option '-t, --text [selector]', 'Output inner text of items, matching the selector'
	.option '-h, --html [selector]', 'Output HTML content of items, matching the selector'
	.option '-c, --count [selector]', 'Output count if items, matching the selector'
	.option '--no-trailing-line-break', 'Don\'t output training line break'
	.version package_json.version
	.parse process.argv

process.stdin.setEncoding 'utf8'

process.stdin.on 'readable', ->
	chunk = process.stdin.read();
	input += chunk if chunk isnt null

process.stdin.on 'end', ->
	jsdom.env input,
	[
		"../node_modules/jquery/dist/jquery.js"
	],
	(errors, window) ->
		process.stdout.write String (window.$ program.text).text() if program.text?
		process.stdout.write String (window.$ program.html).html() if program.html?
		process.stdout.write String (window.$ program.count).length if program.count?
		process.stdout.write '\n' if program.trailingLineBreak
		# process.stdout.write (window.$ program.count).length if program.count?
