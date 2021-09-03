#!/bin/bash
echo "Building draft-santesson-svt"
cd svt-main
sh build.sh
cd ..
echo "Building draft-santesson-svt-xml"
cd svt-xml
sh build.sh
cd ..
echo "Building draft-santesson-svt-pdf"
cd svt-pdf
sh build.sh
cd ..
echo "Building draft-santesson-svt-jws"
cd svt-jws
sh build.sh
cd ..
echo "Done"
