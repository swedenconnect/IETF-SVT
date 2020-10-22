#!/bin/bash
rm -rf target
mkdir target
kramdown-rfc2629 draft-santesson-svt-xml.md >target/draft-santesson-svt-xml.xml
xml2rfc target/draft-santesson-svt-xml.xml
cp target/draft-santesson-svt-xml.txt ../draft-santesson-svt-xml.txt
