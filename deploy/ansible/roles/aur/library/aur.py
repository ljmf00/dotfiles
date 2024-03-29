#!/usr/bin/python
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
import json
import os.path
import tarfile
import tempfile
import urllib.parse

from ansible.module_utils.basic import *
from ansible.module_utils.urls import open_url


DOCUMENTATION = '''
---
module: aur
short_description: Manage packages from the AUR
description:
    - Manage packages from the Arch User Repository (AUR)
author:
    - Kewl <xrjy@nygb.rh.bet(rot13)>
options:
    name:
        description:
            - Name or list of names of the package(s) to install or upgrade.

    upgrade:
        description:
            - Whether or not to upgrade whole system.
        type: bool
        default: no

    use:
        description:
            - The helper to use, 'auto' uses the first known helper found and makepkg as a fallback.
        default: auto
        choices: [ auto, yay, pacaur, trizen, pikaur, aurman, makepkg ]

    skip_installed:
        description:
            - Skip operations if the package is present.
        type: bool
        default: no

    skip_pgp_check:
        description:
            - Only valid with makepkg.
              Skip PGP signatures verification of source file.
              This is useful when installing packages without GnuPG (properly) configured.
        type: bool
        default: no

    ignore_arch:
        description:
            - Only valid with makepkg.
              Ignore a missing or incomplete arch field, useful when the PKGBUILD does not have the arch=('yourarch') field.
        type: bool
        default: no

    aur_only:
        description:
            - Limit operation to the AUR. Compatible with yay, aurman, pacaur and trizen.
notes:
  - When used with a `loop:` each package will be processed individually,
    it is much more efficient to pass the list directly to the `name` option.
'''

RETURN = '''
msg:
    description: action that has been taken
helper:
    the helper that was actually used
'''

EXAMPLES = '''
- name: Install trizen using makepkg, skip if trizen is already installed
  aur: name=trizen use=makepkg skip_installed=true
  become: yes
  become_user: aur_builder
'''


def_lang = ['env', 'LC_ALL=C']

use_cmd = {
    'yay': ['yay', '-S', '--noconfirm', '--needed', '--cleanafter', '--noprovides'],
    'pacaur': ['pacaur', '-S', '--noconfirm', '--noedit', '--needed'],
    'trizen': ['trizen', '-S', '--noconfirm', '--noedit', '--needed'],
    'pikaur': ['pikaur', '-S', '--noconfirm', '--noedit', '--needed'],
    'aurman': ['aurman', '-S', '--noconfirm', '--noedit', '--needed', '--skip_news', '--pgp_fetch', '--skip_new_locations'],
    'makepkg': ['makepkg', '--syncdeps', '--install', '--noconfirm', '--needed'],
}

has_aur_option = ['yay', 'pacaur', 'trizen', 'aurman']


def package_installed(module, package):
    """
    Determine if the package is already installed
    """
    rc, _, _ = module.run_command(['pacman', '-Q', package], check_rc=False)
    return rc == 0


def check_packages(module, packages):
    """
    Inform the user what would change if the module were run
    """
    would_be_changed = []

    for package in packages:
        installed = package_installed(module, package)
        if not installed:
            would_be_changed.append(package)

    if would_be_changed:
        status = True
        if len(packages) > 1:
            message = f'{len(would_be_changed)} package(s) would be installed'
        else:
            message = 'package would be installed'
    else:
        status = False
        if len(packages) > 1:
            message = 'all packages are already installed'
        else:
            message = 'package is already installed'
    module.exit_json(changed=status, msg=message)


def install_with_makepkg(module, package):
    """
    Install the specified package with makepkg
    """
    module.get_bin_path('fakeroot', required=True)
    f = open_url(f'https://aur.archlinux.org/rpc/?v=5&type=info&arg={urllib.parse.quote(package)}')
    result = json.loads(f.read().decode('utf8'))
    if result['resultcount'] != 1:
        return (1, '', f'package {package} not found')
    result = result['results'][0]
    f = open_url('https://aur.archlinux.org/{}'.format(result['URLPath']))
    current_path = os.getcwd()
    with tempfile.TemporaryDirectory() as tmpdir:
        os.chdir(tmpdir)
        tar_file = '{}.tar.gz'.format(result['Name'])
        with open(tar_file, 'wb') as out:
            out.write(f.read())
        tar = tarfile.open(tar_file)
        tar.extractall()
        tar.close()
        os.chdir(format(result['Name']))
        if module.params['skip_pgp_check']:
            use_cmd['makepkg'].append('--skippgpcheck')
        if module.params['ignore_arch']:
            use_cmd['makepkg'].append('--ignorearch')
        rc, out, err = module.run_command(use_cmd['makepkg'], check_rc=True)
        os.chdir(current_path)
    return (rc, out, err)


def upgrade(module, use, aur_only):
    """
    Upgrade the whole system
    """
    assert use in use_cmd

    rc, out, err = module.run_command(def_lang + use_cmd[use] + ['--aur' if (aur_only and use in has_aur_option) else None] + ['-u'], check_rc=True)

    module.exit_json(
        changed=not (out == '' or 'nothing to do' in out or 'No AUR updates found' in out),
        msg='upgraded system',
        helper=use,
    )


def install_packages(module, packages, use, skip_installed, aur_only):
    """
    Install the specified packages
    """
    assert use in use_cmd

    changed_iter = False

    for package in packages:
        if skip_installed:
            if package_installed(module, package):
                rc = 0
                continue
        if use == 'makepkg':
            rc, out, err = install_with_makepkg(module, package)
        else:
            rc, out, err = module.run_command(def_lang + use_cmd[use] + ['--aur' if (aur_only and use in has_aur_option) else None] + [package], check_rc=True)

        changed_iter = changed_iter or not (out == '' or '-- skipping' in out or 'nothing to do' in out)

    message = 'installed package(s)' if changed_iter else 'package(s) already installed'

    module.exit_json(
        changed=changed_iter,
        msg=message if not rc else err,
        helper=use,
        rc=rc,
    )


def main():
    module = AnsibleModule(
        argument_spec={
            'name': {
                'type': 'list',
            },
            'ignore_arch': {
                'default': False,
                'type': 'bool',
            },
            'upgrade': {
                'default': False,
                'type': 'bool',
            },
            'use': {
                'default': 'auto',
                'choices': ['auto'] + list(use_cmd.keys()),
            },
            'skip_installed': {
                'default': False,
                'type': 'bool',
            },
            'skip_pgp_check': {
                'default': False,
                'type': 'bool',
            },
            'aur_only': {
                'default': False,
                'type': 'bool',
            },
        },
        required_one_of=[['name', 'upgrade']],
        supports_check_mode=True,
    )

    params = module.params

    if module.check_mode:
        check_packages(module, params['name'])

    if params['use'] == 'auto':
        use = 'makepkg'
        # auto: select the first helper for which the bin is found
        for k in use_cmd:
            if module.get_bin_path(k):
                use = k
                break
    else:
        use = params['use']

    if params['upgrade'] and (params['name'] or params['skip_installed'] or use == 'makepkg'):
        module.fail_json(msg="Upgrade cannot be used with this option.")
    else:
        if params['upgrade']:
            upgrade(module, use, params['aur_only'])
        else:
            install_packages(module, params['name'], use, params['skip_installed'], params['aur_only'])


if __name__ == '__main__':
    main()
