{exec} = require 'child_process'

exports.Count =

	'1': (test) ->
		exec 'echo "<html>test<div>le</div></html>" | lib/cli --count html --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, '1'

			test.done()

	'2': (test) ->
		exec 'echo "<html>test<div>le</div></html>" | lib/cli --count div --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, '1'

			test.done()

	'3': (test) ->
		exec 'echo "<div>test</div><div>le</div>" | lib/cli --count div --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, '2'

			test.done()
