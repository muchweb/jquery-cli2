{exec} = require 'child_process'

exports.Errors =

	'1': (test) ->
		exec 'echo "<html>test<div>le</div></html>" | lib/cli --selector', (error, stdout, stderr) ->
			test.notStrictEqual error, null
			test.done()
