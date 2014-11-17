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
	.option '--text [selector]', 'Output inner text of items, matching the selector'
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
		process.stdout.write (window.$ program.text).text() if program.text?
