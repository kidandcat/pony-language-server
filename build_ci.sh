#! /bin/bash
sudo apt update && sudo apt install gcc -y
# SCRIPT
set -e
# set -x
export SHELL=/bin/bash
# Linux
export PATH=/home/runner/.local/share/ponyup/bin:$PATH
# MacOS
export PATH=/Users/runner/.local/share/ponyup/bin:$PATH
sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ponylang/ponyup/latest-release/ponyup-init.sh)"

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }
cd ponyc && git fetch --all --tags
for PONY_VERSION in $(git tag)
do
    if [ $(version $PONY_VERSION) -ge $(version "0.54.0") ]; then
        echo "Building with ponyc version: $PONY_VERSION"
        ponyup update ponyc release-$PONY_VERSION
        # copy stdlib to extension
        git checkout tags/$PONY_VERSION
        cd $GITHUB_WORKSPACE && cp -r ponyc/packages client_vscode
        # build pony-lsp
        cd $GITHUB_WORKSPACE
        ponyc -b pony-lsp -o client_vscode
        # compile the extension
        cd $GITHUB_WORKSPACE/client_vscode
        npm i
        npm i -g vsce
        npm run compile
        vsce package
    else
        echo "Only versions greater than 0.54.0 are supported. Discarding $PONY_VERSION"
    fi
done
