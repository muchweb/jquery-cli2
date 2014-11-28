{exec} = require 'child_process'

exports.Text =

	'1': (test) ->
		exec 'echo "<html>test<div>le</div></html>" | lib/cli --selector \'html\' --text --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, 'testle\n'

			test.done()

	'2': (test) ->
		exec 'echo "<html>test<div>le</div></html>" | lib/cli --selector \'div\' --text --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, 'le'

			test.done()

	'3': (test) ->
		exec 'echo "<div>test</div><div>le</div>" | lib/cli --selector \'div\' --text --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, 'test\nle'

			test.done()
