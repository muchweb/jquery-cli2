###*
	@module jquery-cli2
	@author muchweb
###

'use strict'

jsdom = require 'jsdom'
program = require 'commander'
package_json = require '../package.json'
input = ''

program
	.option '-s, --selector [selector]', 'Output inner text of items, matching the selector'
	.option '-t, --text', 'Output inner text of items, matching the selector'
	.option '-h, --html', 'Output HTML content of items, matching the selector'
	.option '-c, --count', 'Output count if items, matching the selector'
	.option '-a, --attr [name]', 'Return specific attr value of matched elements'
	.option '-f, --format [name]', 'Allowed formats are \'text\' or \'json\''
	.option '--no-trailing-line-break', 'Don\'t output training line break'
	# .option '--no-preserve-linebreaks', 'Keep inner line breaks'
	.version package_json.version
	.parse process.argv

process.stdin.setEncoding 'utf8'

process.stdin.on 'readable', ->
	chunk = process.stdin.read();
	input += chunk if chunk isnt null

process.stdin.on 'end', ->
	jsdom.env input,
	[
		'../node_modules/jquery/dist/jquery.js'
	], (errors, window) ->
		throw new Error 'Please specify a selector. Use -h to show usage information' unless program.selector?
		items = window.$ program.selector
		result = []

		if items.length > 0
			items.each ->
				result.push (window.$ this).length if program.count?
				result.push (window.$ this).text() if program.text?
				result.push (window.$ this).html() if program.html?
				result.push (window.$ this).attr program.attr if program.attr?

		switch program.format
			when 'json' then process.stdout.write JSON.stringify result
			else
				result.map (item) ->
					(String item).replace /(\r\n|\n|\r)/gm, ''
				process.stdout.write result.join '\n'

		# Trailing new line
		process.stdout.write '\n' if program.trailingLineBreak
