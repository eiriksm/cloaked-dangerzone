compile:
		./node_modules/.bin/coffee --compile --output lib/ src/

test-cov:
	echo "awesome"

test:
		./node_modules/.bin/coffee --compile --output test/ test/
		./node_modules/mocha/bin/mocha

.PHONY: compile test
