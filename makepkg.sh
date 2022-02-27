#!/usr/bin/bash -x

python setup.py develop
python setup.py sdist

pypkg=`ls -t dist/ | head -1`

twine check dist/${pypkg}
