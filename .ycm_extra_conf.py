#!/usr/bin/env python

import os

def FlagsForFile(filename, **kwargs):
    _, ext = os.path.splitext(filename)

    flags = [
        '-Wall',
        '-Wextra',
        '-I',
        '.',
        '-isystem',
        '/usr/include/c++/7.1.1',
        '-isystem',
        '/usr/local/include',
        '-isystem',
        '/usr/include/x86_64-linux-gnu',
        '-isystem',
        '/usr/include'
    ]

    if ext == '.c':
        flags += ['-x', 'c', '-stdlib=libc', '-std=gnu99']
    elif ext in ('.cpp', '.cxx', '.cc', '.h', '.hpp'):
        flags += ['-x', 'c++', '-stdlib=libc++', '-std=gnu++17']

    return {'flags': flags}
