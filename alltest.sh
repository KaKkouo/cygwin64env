#!/usr/bin/bash -x

python setup.py clean

python src/__init__.py
python setup.py test

python setup.py clean
