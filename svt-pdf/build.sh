#!/bin/bash
rm -rf target
mkdir target
kramdown-rfc2629 draft-santesson-svt-pdf.md >target/draft-santesson-svt-pdf.xml
xml2rfc target/draft-santesson-svt-pdf.xml
cp target/draft-santesson-svt-pdf.txt ../draft-santesson-svt-pdf.txt
