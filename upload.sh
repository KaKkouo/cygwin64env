#!/usr/bin/bash
#site: testpypi or pypi (see : ~/.pypirc)

site=${1}
dist=${2}

twine upload -r ${site} ${dist}
