###*
	@module jquery-cli2
	@author muchweb
###

'use strict'

jsdom  = require 'jsdom'
config = require '../package.json'
input  = ''

args = process.argv.slice 2
while args.length isnt 0
	arg = args.shift()

	switch arg

		when '-v', '--version'
			process.stdout.write "#{config.version}\n"
			return

		when '-h', '--help'
			process.stdout.write """
				#{config.name}: #{config.description}"
				Usage: #{config.name} [OPTION]…

				Filtering elements:
				  -s, --selector {selector}    Output inner text of items, matching the selector

				Outputting results:
				  -h, --html                   Output HTML content of items, matching the selector
				  -t, --text                   Output inner text of items, matching the selector
				  -c, --count                  Output count if items, matching the selector
				  -a, --attr {name}            Return specific attr value of matched elements

				Modifying document:
				  -r, --remove                 Remove an element. Root element will get re-selected

				Output formatting:
				  -f, --format {text|json}     Allowed formats are 'text' or 'json'
				  -n, --no-trailing-line-break Don't output training line break

				Miscellaneous:
				  -h, --help                   Show this help message
				  -v, --version                Output package version
			"""
			return

process.stdin.setEncoding 'utf8'

process.stdin.on 'readable', ->
	chunk = process.stdin.read();
	input += chunk if chunk isnt null

process.stdin.on 'end', ->
	expect_input = (args) ->
		throw new Error 'Expecting an argument, nothing found' if args.length is 0
		args.shift()

	jsdom.env input, [
		'../node_modules/jquery/dist/jquery.js'
	], (errors, window) ->
		item = window.$ ':root'
		result = []
		format = 'text'
		trailinglinebreak = yes

		args = process.argv.slice 2
		while args.length isnt 0
			arg = args.shift()

			switch arg

				when '-s', '--selector'
					finder = expect_input args
					item = item.find finder

				when '-h', '--html'
					item.each -> result.push (window.$ this).html()

				when '-t', '--text'
					item.each -> result.push (window.$ this).text()

				when '-c', '--count'
					item.each -> result.push (window.$ this).length

				when '-a', '--attr'
					finder = expect_input args
					item.each -> result.push (window.$ this).attr finder

				when '-r', '--remove'
					item.remove()
					item = window.$ ':root'

				when '-f', '--format'
					finder = expect_input args
					item.each -> result.push (window.$ this).attr finder

				when '-n', '--no-trailing-line-break'
					trailinglinebreak = no

		switch format
			when 'json'
				process.stdout.write JSON.stringify result
			else
				result = result.map (item) ->
					(String item).replace /(\r\n|\n|\r)/gm, ''
				process.stdout.write result.join '\n'

		# Trailing new line
		process.stdout.write '\n' if trailinglinebreak
