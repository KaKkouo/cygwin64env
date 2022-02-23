#!/usr/bin/bash -x

python setup.py develop
python setup.py sdist

echo "exec: twine check [pkg]"
