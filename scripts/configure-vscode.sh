#!/usr/bin/env bash

set -eo pipefail

SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do
  DOTFILES_FOLDER="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$DOTFILES_FOLDER/$SOURCE"
done
DOTFILES_FOLDER="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
DOTFILES_FOLDER="$(dirname $DOTFILES_FOLDER)"
unset SOURCE

echo "Remove created folders for vscode variants and link them instead..."

mkdir -vp "$HOME/.vscode/"
mkdir -vp "$HOME/.vscode/extensions/"

[[ ! -L "$HOME/.vscode-insiders/" && ! -d "$HOME/.vscode-insiders/" ]] && (rm -rvf "$HOME/.vscode-insiders/"; ln -sfv .vscode "$HOME/.vscode-insiders")
[[ ! -L "$HOME/.vscode-oss/" && ! -d "$HOME/.vscode-oss/" ]] && (rm -rvf "$HOME/.vscode-oss/"; ln -sfv .vscode "$HOME/.vscode-oss")

mkdir -vp "$HOME/.config/Code/"

[[ ! -L "$HOME/.config/Code - OSS/" && ! -d "$HOME/.config/Code - OSS/" ]] && (rm -rvf "$HOME/.config/Code - Insiders/"; ln -sfv "Code/" "$HOME/.config/Code - OSS")
[[ ! -L "$HOME/.config/Code - Insiders/" && ! -d "$HOME/.config/Code - Insiders/" ]] && (rm -rvf "$HOME/.config/Code - OSS/"; ln -sfv "Code/" "$HOME/.config/Code - Insiders")

cp -r "$HOME/.config/Code/" .local/share/code-server/

echo "Installing extensions..."

INSTALL_VSCODE_EXT_SCRIPT="$DOTFILES_FOLDER/scripts/install-vscode-extensions.sh"

source "$DOTFILES_FOLDER/scripts/utils-job-pool.sh"

job_pool_init 30 0

set +e +o pipefail

# Theme and Icons
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" vscode-icons-team.vscode-icons
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" pkief.material-icon-theme
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" divyanshu013.vscode-material-darker
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" zhuangtongfa.Material-theme

# Keymaps
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" aurorafoss.vscode-bettercoder

# Linters and autocomplete
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" VisualStudioExptTeam.vscodeintellicode # General
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" dbaeumer.vscode-eslint # Javascript and typescript
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" stylelint.vscode-stylelint # CSS/SASS
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" Wscats.eno # CSS/SASS
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" christian-kohler.path-intellisense # Paths autocomplete
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" DavidAnson.vscode-markdownlint # Markdown
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" SonarSource.sonarlint-vscode
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" shengchen.vscode-checkstyle
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" timonwong.shellcheck
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" tsqllint.tsqllint

# Prettify Extensions
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" esbenp.prettier-vscode
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" HookyQR.beautify
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" Leopotam.csharpfixformat # C# Formatter

# Snippets
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" jorgeserrano.vscode-csharp-snippets # C#
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" abusaidm.html-snippets # HTML

# Programming language support
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" webfreak.dlang-bundle # D
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" webfreak.code-d # D Language Server
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-vscode.vscode-typescript-next # Typescript
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" vscjava.vscode-java-pack # Java
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" dgileadi.java-decompiler # Java Decompiler
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-vscode.cpptools-extension-pack # C/C++
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-vscode.cpptools # C/C++
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-dotnettools.csharp # C#
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-python.python # Python
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-python.vscode-pylance # Python
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" golang.Go # Go
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" rust-lang.rust # Rust
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" GraphQL.vscode-graphql # GraphQL
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" naco-siren.gradle-language # Gradle
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" fwcd.kotlin # Kotlin
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" trixnz.vscode-lua # Lua
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" felixfbecker.php-intellisense # PHP
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" bmewburn.vscode-intelephense-client # PHP
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" felixfbecker.php-debug # PHP Debug
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" redhat.vscode-yaml # Yaml
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" redhat.vscode-xml # XML
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" Dart-Code.dart-code # Dart
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-vscode.PowerShell # PowerShell
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" jebbs.plantuml # PlantUML
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" 13xforever.language-x86-64-assembly # x86 and x86_64 Assembly
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-mssql.mssql # MS/SQL
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" Oracle.oracledevtools Oracle SQL

# Frameworks and Libraries
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" Dart-Code.flutter # Flutter
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" shrey150.javafx-support # JavaFX
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" octref.vetur # Vue
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" Angular.ng-template # Angular
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" vscjava.vscode-spring-initializr # Spring
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" Pivotal.vscode-spring-boot # Spring
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" vscjava.vscode-spring-boot-dashboard # Spring

# Tools and technologies support
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-kubernetes-tools.vscode-kubernetes-tools # Kubernetes
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" eamodio.gitlens # Git
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-azuretools.vscode-docker # Docker
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" eg2.vscode-npm-script # Npm
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" redhat.datavirt-extension-pack # Data virtualization
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" GitLab.gitlab-workflow # Gitlab
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" GitHub.vscode-pull-request-github # Github
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" WakaTime.vscode-wakatime # Wakatime
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" thekalinga.bootstrap4-vscode # Bootstrap
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" asabil.meson # Meson
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" surajbarkale.ninja # Ninja
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" platformio.platformio-ide # PlatformIO
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" satoqz.yet-another-discord-presence # Discord
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" shyykoserhiy.vscode-spotify # Spotify
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" BazelBuild.vscode-bazel # Bazel
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" humao.rest-client # Rest API Client

# Remote and instance share extensions
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-vscode-remote.vscode-remote-extensionpack
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-vscode-remote.remote-ssh
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-vscode-remote.remote-ssh-edit
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-vscode-remote.remote-containers
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" MS-vsliveshare.vsliveshare
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" github.codespaces
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-vsonline.vsonline

# Misc
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" msjsdiag.debugger-for-chrome
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" wayou.vscode-todo-highlight
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" redhat.fabric8-analytics
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" redhat.project-initializer
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" redhat.vscode-server-connector
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ms-vscode.hexeditor
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" CoenraadS.bracket-pair-colorizer-2
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" aaron-bond.better-comments
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" formulahendry.code-runner
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" ritwickdey.LiveServer
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" webfreak.debug
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" pflannery.vscode-versionlens
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" snyk-security.vscode-vuln-cost
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" obenjiro.arrr
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" formulahendry.auto-close-tag
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" formulahendry.auto-rename-tag
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" k--kato.docomment # C# XML Comments
job_pool_run "$INSTALL_VSCODE_EXT_SCRIPT" techer.open-in-browser # Open browser

job_pool_wait
job_pool_shutdown

exit 0
