{exec} = require 'child_process'

exports.Html =

	'1': (test) ->
		exec 'echo "<section>test<div>le</div></section>" | lib/cli --selector \'section\' --html --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, 'test<div>le</div>'

			test.done()

	'2': (test) ->
		exec 'echo "<html>test<div>le</div></html>" | lib/cli --selector \'div\' --html --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, 'le'

			test.done()

	'3': (test) ->
		exec 'echo "<div>test</div><div>le</div>" | lib/cli --selector \'div\' --html --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, 'test\nle'

			test.done()
