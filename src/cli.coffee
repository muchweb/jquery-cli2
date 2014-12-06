###*
	@module jquery-cli2
	@author muchweb
###

'use strict'

jsdom  = require 'jsdom'
config = require '../package.json'
input  = ''

class Cli2
	constructor: (html='', @args) ->
		@result = []
		@format = 'text'
		@trailing_line_break = yes
		jsdom.env html, [
			'../node_modules/jquery/dist/jquery.js'
		], (error, @window) =>
			throw error if error isnt null
			@SetPointer()
			return if @ParseInitial()
			return if @ParseMain()

	InvalidInput: (arg) ->
		throw new Error "Invalid argument: \'#{arg}\'.\nTry \'-h\' or \'--help\' for more information."

	ExpectInput: (args) ->
		throw new Error 'Expecting an argument, nothing found' if args.length is 0
		args.shift()

	SetPointer: (path=':root') ->
		@pointer = @window.$ path

	ParseInitial: ->
		args = @args.slice 0
		args.push '-h' if args.length is 0
		while args.length isnt 0
			arg = args.shift()
			switch arg
				when '-v', '--version'
					process.stdout.write "#{config.version}\n"
					return true

				when '-h', '--help'
					process.stdout.write """
						#{config.name}: #{config.description}
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
					return true
		false

	ParseMain: ->
		current = @
		args = @args.slice 0
		while args.length isnt 0
			arg = args.shift()
			switch arg

				when '-s', '--selector'
					@SetPointer @pointer.find @ExpectInput args

				when '-h', '--html'
					@pointer.each (item) => @result.push (@window.$ item).html()

				when '-t', '--text'
					@pointer.each (item) => @result.push (@window.$ item).text()

				when '-c', '--count'
					@pointer.each (item) => @result.push (@window.$ item).length

				when '-a', '--attr'
					@pointer.each (item) => @result.push (@window.$ item).attr @ExpectInput args

				when '-r', '--remove'
					@pointer.remove()
					@SetPointer()

				when '-f', '--format'
					@pointer.each (item) => @result.push (@window.$ item).attr @ExpectInput args

				when '-n', '--no-trailing-line-break'
					@trailing_line_break = no

				else
					@InvalidInput arg

		switch @format
			when 'json'
				process.stdout.write JSON.stringify @result
			else
				@result = @result.map (item) =>
					(String item).replace /(\r\n|\n|\r)/gm, ''
				process.stdout.write @result.join '\n'

		# Trailing new line
		process.stdout.write '\n' if @trailing_line_break

process.stdin.setEncoding 'utf8'

process.stdin.on 'readable', ->
	chunk = process.stdin.read();
	input += chunk if chunk isnt null

process.stdin.on 'end', ->
	cli2 = new Cli2 input, process.argv.slice 2
