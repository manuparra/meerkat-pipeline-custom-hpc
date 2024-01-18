echo "Adding processMeekKAT to the path. Now you can use processMeerKAT from your data/code folder"
echo "-----------------------"
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/processMeerKAT"
export PATH=$PATH:$dir
export PYTHONPATH=$PYTHONPATH:$dir
