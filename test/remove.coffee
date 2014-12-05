{exec} = require 'child_process'

exports.Remove =

	'1': (test) ->
		exec 'echo "<div>test<strong>le</strong>success</div>" | lib/cli --selector \'strong\' --remove  --selector \'div\' --text --no-trailing-line-break', (error, stdout, stderr) ->
			test.strictEqual error, null
			test.strictEqual stderr, ''
			test.strictEqual stdout, 'testsuccess'

			test.done()
