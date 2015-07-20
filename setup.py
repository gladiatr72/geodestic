# pylint: disable=invalid-name,missing-docstring,line-too-long

from __future__ import print_function

import os
import re
from subprocess import Popen, PIPE
from distutils.core import setup
from distutils.extension import Extension


VERSION = '0.2.1'

REQUIRES = ['cython>=0.2', 'pip']

CPATH_BASE_ = []
CFLAGS = []
LD_LIBRARY_PATH = []

INC_PATHS = []
LIB_PATHS = []

try:
    from Cython.Build import cythonize
    CYTHON = True
except ImportError:
    print('\nWARNING: Cython not installed.')


if CYTHON:
    cmdlist = 'pip show cython'.split(' ')
    proc = Popen(cmdlist, stdout=PIPE, stderr=PIPE)
    out, err = proc.communicate()

    PY_BASE_res = re.search(
        r'(?:Location:\s([^\n]*))\n',
        out,
        flags=re.DOTALL)

    if PY_BASE_res:
        CPATH_BASE_ = PY_BASE_res.groups()[0]


    ext_modules = [
        Extension(
            'geodestic',
            ['src/geodestic.pyx'],
            libraries=['m'])
    ]

    setup(
        ext_modules=cythonize(ext_modules),
        name='geodestic',
        version=VERSION,
        description='A Cython implementation of android.location.Location.computeDistanceAndBearing()',
        url='https://github.com/gladiatr72/geodestic',
        author='Stephen Spencer',
        author_email='gladiatr72@gmail.com',
        keywords=['geolocation',],
        license='Apache 2.0',
        classifiers=[
            'Development Status :: 4 - Beta',
            'Environment :: Other Environment',
            'Intended Audience :: Developers',
            'License :: OSI Approved :: Apache Software License',
            'Operating System :: POSIX :: Linux',
            'Operating System :: MacOS :: MacOS X',
            'Programming Language :: Cython',
            'Topic :: Scientific/Engineering :: GIS',
            'Topic :: Software Development :: Libraries :: Python Modules',
        ]
    )


