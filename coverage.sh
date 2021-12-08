#!/usr/bin/bash -x

if [ "$1" = "old" ]
then
	coverage run --source=src setup.py test
else
	pytest --doctest-modules --cov=src --cov-report=term-missing tests
fi
coverage report -m | tee COVERAGE.txt
