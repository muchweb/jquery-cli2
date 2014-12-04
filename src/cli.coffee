###*
	@module jquery-cli2
	@author muchweb
###

'use strict'

jsdom     = require 'jsdom'
commander = require 'commander'
config    = require '../package.json'
input     = ''

commander
	.option '-s, --selector [selector]', 'Output inner text of items, matching the selector'
	.option '-t, --text', 'Output inner text of items, matching the selector'
	.option '-h, --html', 'Output HTML content of items, matching the selector'
	.option '-c, --count', 'Output count if items, matching the selector'
	.option '-a, --attr [name]', 'Return specific attr value of matched elements'
	.option '-f, --format [name]', 'Allowed formats are \'text\' or \'json\''
	.option '--no-trailing-line-break', 'Don\'t output training line break'
	# .option '--no-preserve-linebreaks', 'Keep inner line breaks'
	.version config.version
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
		throw new Error 'Please specify a selector. Use -h to show usage information' unless commander.selector?
		items = window.$ commander.selector
		result = []

		if items.length > 0
			items.each ->
				result.push (window.$ this).length if commander.count?
				result.push (window.$ this).text() if commander.text?
				result.push (window.$ this).html() if commander.html?
				result.push (window.$ this).attr commander.attr if commander.attr?

		switch commander.format
			when 'json' then process.stdout.write JSON.stringify result
			else
				result.map (item) ->
					(String item).replace /(\r\n|\n|\r)/gm, ''
				process.stdout.write result.join '\n'

		# Trailing new line
		process.stdout.write '\n' if commander.trailingLineBreak
