{exec} = require 'child_process'

exports.Piping =

	'1': (test) ->
		exec 'echo "<section><div><ul><li>testing</li></ul></div><section>" | lib/cli --html div --no-trailing-line-break | lib/cli --html ul --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, '<li>testing</li>'

			test.done()
