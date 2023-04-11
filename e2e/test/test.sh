#!/bin/sh

set -e

rm -rf build source

cd `dirname $0`
cat <<-EOF | sphinx-quickstart
y
prohect
author
release
ja
EOF
echo "" >> ./source/index.rst
echo ".. uml::" >> ./source/index.rst
echo "    " >> ./source/index.rst
echo "    Hogeほげ --> Piyoぴよ" >> ./source/index.rst

echo "" >> ./source/conf.py
echo "extensions += ['sphinxcontrib.plantuml']" >> ./source/conf.py
echo "plantuml = 'java -jar /opt/plantuml/plantuml.jar'" >> ./source/conf.py

make html

cat ./build/html/index.html | grep "<img" | grep ".png" || exit 1
cp -r ./build/html /result
