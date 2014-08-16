dart-compile:
	dart2js --out=static/dartangular/build/web/dartangular.dart.js static/dartangular/web/dartangular.dart -m

compile:
		./node_modules/.bin/coffee --compile --output lib/ src/

test-cov:
		./node_modules/.bin/coffee --compile --output test/ test/
		node ./node_modules/istanbul/lib/cli.js cover ./node_modules/mocha/bin/_mocha
		- cat coverage/lcov.info | ./node_modules/coveralls/bin/coveralls.js > /dev/null 2>&1

test:
		./node_modules/.bin/coffee --compile --output test/ test/
		./node_modules/mocha/bin/mocha

.PHONY: compile test test-cov
