#!/bin/bash
rm -rf target
mkdir target
kramdown-rfc2629 draft-santesson-svt-jws.md >target/draft-santesson-svt-jws.xml
xml2rfc target/draft-santesson-svt-jws.xml
cp target/draft-santesson-svt-jws.txt ../draft-santesson-svt-jws.txt
