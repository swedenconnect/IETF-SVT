#!/bin/bash
rm -rf target
mkdir target
kramdown-rfc2629 draft-santesson-svt.md >target/draft-santesson-svt.xml
xml2rfc target/draft-santesson-svt.xml
cp target/draft-santesson-svt.txt ../draft-santesson-svt.txt
