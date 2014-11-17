{exec} = require 'child_process'

exports.Text =

	'1': (test) ->
		exec 'echo "<html>test<div>le</div></html>" | lib/cli --text html --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, 'testle\n'

			test.done()

	'2': (test) ->
		exec 'echo "<html>test<div>le</div></html>" | lib/cli --text div --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, 'le'

			test.done()

	'3': (test) ->
		exec 'echo "<div>test</div><div>le</div>" | lib/cli --text div --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, 'testle'

			test.done()
