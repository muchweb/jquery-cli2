{exec} = require 'child_process'

exports.Piping =

	'1': (test) ->
		exec 'echo "<section><div><ul><li>testing</li></ul></div><section>" | lib/cli --selector \'div\' --html --no-trailing-line-break | lib/cli --selector \'ul\' --html --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, '<li>testing</li>'

			test.done()
