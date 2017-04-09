#
# linter.py
# Linter for SublimeLinter3, a code checking framework for Sublime Text 3
#
# Written by cjami
# Copyright (c) 2017 cjami
#
# License: MIT
#

"""This module exports the Wslphpcs plugin class."""

from SublimeLinter.lint import Linter, util


class Wslphpcs(Linter):
    """Provides an interface to wslphpcs."""

    syntax = ('php', 'html', 'html 5')
    regex = (
        r'.*line="(?P<line>\d+)" '
        r'column="(?P<col>\d+)" '
        r'severity="(?:(?P<error>error)|(?P<warning>warning))" '
        r'message="(?P<message>.*)" source'
    )
    executable = 'wslphpcs'
    defaults = {
        '--standard=': 'PSR2',
    }
    inline_overrides = ('standard')
    # tempfile_suffix = 'php'

    def cmd(self):
        """Return the command line to execute."""
        command = [self.executable_path, '@']

        command.append('--report=checkstyle')

        return command + ['*', '-']