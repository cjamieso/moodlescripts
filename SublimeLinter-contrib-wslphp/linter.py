#
# linter.py
# Linter for SublimeLinter3, a code checking framework for Sublime Text 3
#
# Written by cjami
# Copyright (c) 2017 cjami
#
# License: MIT
#

"""This module exports the Wslphp plugin class."""

from SublimeLinter.lint import Linter, util


class Wslphp(Linter):
    """Provides an interface to wslphp."""

    syntax = ('php', 'html')
    regex = (
        r'^(?:Parse|Fatal) (?P<error>error):(\s*(?P<type>parse|syntax) error,?)?\s*'
        r'(?P<message>(?:unexpected \'(?P<near>[^\']+)\')?.*) in .* on line (?P<line>\d+)'
    )
    executable = 'wslphp'

    def split_match(self, match):
        """Return the components of the error."""
        match, line, col, error, warning, message, near = super().split_match(match)

        # message might be empty, we have to supply a value
        if match and match.group('type') == 'parse' and not message:
            message = 'parse error'

        return match, line, col, error, warning, message, near

    def cmd(self):
        command = [self.executable_path, '@']
        command.append('-l')
        command.append('-n')
        command.append('-d')
        command.append('display_errors=On')
        command.append('-d')
        command.append('log_errors=Off')

        return command + ['*', '-']