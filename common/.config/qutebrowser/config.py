"""Qutebrowser configuration."""
from os.path import expanduser

from qutebrowser.config.config import ConfigContainer
from qutebrowser.config.configfiles import ConfigAPI
# pylint: disable=C0111
config: ConfigAPI = config  # pylint: disable=E0601,E0602,C0103
c: ConfigContainer = c  # pylint: disable=E0601,E0602,C0103

config.load_autoconfig(True)

home_dir = expanduser('~')
home_bin_dir = home_dir + '/.local/bin'

config.bind(',M', "hint links spawn " + home_bin_dir + "/umpv {hint-url}")
config.bind(';M', "hint --rapid links spawn " + home_bin_dir + "/umpv {hint-url}")  # noqa: E501
config.bind(',m', "spawn " + home_bin_dir + "/umpv {url}")
