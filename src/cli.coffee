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
			process.stdout.write "#{config.name}: #{config.description}\n"
			process.stdout.write "Usage: #{config.name} [OPTION]…\n"
			process.stdout.write '\n'
			process.stdout.write 'Filtering elements:\n'
			process.stdout.write '  -s, --selector {selector}    Output inner text of items, matching the selector\n'
			process.stdout.write '\n'
			process.stdout.write 'Outputting results:\n'
			process.stdout.write '  -h, --html                   Output HTML content of items, matching the selector\n'
			process.stdout.write '  -t, --text                   Output inner text of items, matching the selector\n'
			process.stdout.write '  -c, --count                  Output count if items, matching the selector\n'
			process.stdout.write '  -a, --attr {name}            Return specific attr value of matched elements\n'
			process.stdout.write '\n'
			process.stdout.write 'Modifying document:\n'
			process.stdout.write '  -r, --remove                 Remove an element. Root element will get re-selected\n'
			process.stdout.write '\n'
			process.stdout.write 'Output formatting:\n'
			process.stdout.write '  -f, --format {text|json}     Allowed formats are \'text\' or \'json\'\n'
			process.stdout.write '  -n, --no-trailing-line-break Don\'t output training line break\n'
			process.stdout.write '\n'
			process.stdout.write 'Miscellaneous:\n'
			process.stdout.write '  -h, --help                   Show this help message\n'
			process.stdout.write '  -v, --version                Output package version\n'
			return

process.stdin.setEncoding 'utf8'

process.stdin.on 'readable', ->
	chunk = process.stdin.read();
	input += chunk if chunk isnt null

process.stdin.on 'end', ->
	jsdom.env input, [
		'../node_modules/jquery/dist/jquery.js'
	], (errors, window) ->
		item = window.$ ':root'
		result = []
		format = 'text'
		trailinglinebreak = yes

		while args.length isnt 0
			arg = args.shift()

			switch arg

				when '-s', '--selector'
					finder = args.shift()
					item = item.find finder

				when '-h', '--html'
					item.each -> result.push (window.$ this).html()

				when '-t', '--text'
					item.each -> result.push (window.$ this).text()

				when '-c', '--count'
					item.each -> result.push (window.$ this).length

				when '-a', '--attr'
					finder = args.shift()
					item.each -> result.push (window.$ this).attr finder

				when '-r', '--remove'
					item.remove()
					item = window.$ ':root'

				when '-f', '--format'
					finder = args.shift()
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
