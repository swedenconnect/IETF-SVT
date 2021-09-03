---
title: XML Signature Validation Token
docname: draft-santesson-svt-xml-02
date: 2021-09-02
category: info
consensus: true

ipr: trust200902
area: Security
keyword: Internet-Draft

stand_alone: no
pi: [toc, sortrefs, symrefs]

author:
 -
    ins: S. Santesson
    name: Stefan Santesson
    org: IDsec Solutions AB
    abbrev: IDsec Solutions
    street: Forskningsbyn Ideon
    city: Lund
    code: "223 70"
    country: SE
    email: sts@aaa-sec.com

 -
    ins: R. Housley
    name: Russ Housley
    org: Vigil Security, LLC
    abbrev: Vigil Security
    street: 516 Dranesville Road
    city: Herndon, VA
    code: 20170
    country: US
    email: housley@vigilsec.com

normative:
  RFC2119:
  RFC5280:
  RFC7515:
  RFC8174:
  XMLDSIG11:
    title: "XML Signature Syntax and Processing Version 1.1"
    author:
    -
      ins: D. Eastlake
      name: Donald Eastlake
    -
      ins: J. Reagle
      name: Joseph Reagle
    -
      ins: D. Solo
      name: David Solo
    -
      ins: F. Hirsch
      name: Frederick Hirsch
    -
      ins: M. Nystrom
      name: Magnus Nystrom
    -
      ins: T. Roessler
      name: Thomas Roessler
    -
      ins: K. Yiu
      name: Kelvin Yiu
    date: 2013-04-11
    seriesinfo:
      "W3C": "Proposed Recommendation"
  SVT:
    title: "Signature Validation Token"
    author:
    -
      ins: S. Santesson
      name: Stefan Santesson
    -
      ins: R. Housley
      name: Russ Housley
    date: 2021-09
    seriesinfo:
      "IETF": "draft-santesson-svt-02"

--- abstract

This document defines a XML profile for the Signature Validation Token defined in {{SVT}}.

--- middle

# Introduction {#intro}

The "Signature Validation Token" specification {{SVT}} defines the basic token to support signature validation in a way that can significantly extend the lifetime of a signature.

This specification defines a profile for implementing SVT with a signed XML document, and defines the following aspects of SVT usage:

- How to include reference data related to XML signatures and XML documents in an SVT.
- How to add an SVT token to a XML signature.

XML documents can have any number of signature elements, signing an arbitrary number of fragments of XML documents. The actual signature element may be included in the signed XML document (enveloped), include the signed data (enveloping) or may be separate from the signed content (detached).

To provide a generic solution for any type of XML signature an SVT is added to each XML signature element within the XML signature &lt;ds:Object&gt; element.

# Definitions {#defs}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in BCP&nbsp;14 {{RFC2119}} {{RFC8174}}
when, and only when, they appear in all capitals, as shown here.

The definitions in {{SVT}} apply also to this document.

## Notation {#notation}

### References to XML Elements from XML Schemas {#ref-to-xml-elements}

When referring to elements from the W3C XML Signature namespace
(http://www.w3.org/2000/09/xmldsig\#) the following syntax is used:

-  &lt;ds:Signature&gt;

When referring to elements from the ETSI XAdES XML Signature namespace
(http://uri.etsi.org/01903/v1.3.2#) the following syntax is used:

-  &lt;xades:CertDigest&gt;

When referring to elements defined in this specification
(http://id.swedenconnect.se/svt/1.0/sig-prop/ns) the following syntax is used:

-  &lt;svt:Element&gt;


# SVT in XML Documents {#svt-in-xml}

When SVT is provided for XML signatures then one SVT MUST be provided for each XML signature.

An SVT embedded within the XML signature element MUST be placed in a  &lt;svt:SignatureValidationToken&gt; element as defined in {{signaturevalidationtoken-signature-property}}.

## SignatureValidationToken Signature Property {#signaturevalidationtoken-signature-property}

The &lt;svt:SignatureValidationToken&gt; element MUST be placed in a &lt;ds:SignatureProperty&gt; element in accordance with {{XMLDSIG11}}. The &lt;ds:SignatureProperty&gt; element MUST be placed inside a &lt;ds:SignatureProperties&gt; element inside a &lt;ds:Object&gt; element inside a &lt;ds:Signature&gt; element.

Note: {{XMLDSIG11}} requires the Target attribute to be present in &lt;ds:SignatureProperty&gt;, referencing the signature targeted by this signature property. If an SVT is added to a signature that do not have an Id attribute, implementations SHOULD add an Id attribute to the &lt;ds:Signature&gt; element and reference that Id in the Target attribute. This Id attribute and Target attribute value matching is required by the {{XMLDSIG11}} standard, but it is redundant in the context of SVT validation as the SVT already contains information that uniquely identifies the target signature. Validation applications SHOULD not reject an SVT token because of Id and Target attribute mismatch, and MUST rely on matching against signature using signed information in the SVT itself.

The &lt;svt:SignatureValidationToken&gt; element is defined by the following XML Schema:

~~~
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
    elementFormDefault="qualified"
    targetNamespace="http://id.swedenconnect.se/svt/1.0/sig-prop/ns"
    xmlns:svt="http://id.swedenconnect.se/svt/1.0/sig-prop/ns">

  <xs:element name="SignatureValidationToken"
      type="svt:SignatureValidationTokenType" />

  <xs:complexType name="SignatureValidationTokenType">
    <xs:simpleContent>
      <xs:extension base="xs:string">
      </xs:extension>
    </xs:simpleContent>
  </xs:complexType>

</xs:schema>
~~~

The SVT token MUST be included as a string representation of the SVT JWT. Note that this is the string representation of the JWT without further encoding. The SVT MUST NOT be represented by the Base64 encoded bytes of the JWT string.

Example:

~~~
<ds:Signature Id="MySignatureId">
  ...
  <ds:Object>
    <ds:SignatureProperties>
      <ds:SignatureProperty Target="#MySignatureId">
        <svt:SignatureValidationToken>
              eyJ0eXAiOiJKV1QiLCJhb...2aNZ
        </svt:SignatureValidationToken>
      </ds:SignatureProperty>
    </ds:SignatureProperties>
  </ds:Object>
</ds:Signature>
~~~

## Multiple SVT in a signature {#multiple-svt-tokens}

If a new SVT is stored in a signature which already contains a previously issued SVT, implementations can choose to either replace the existing SVT or to store the new SVT in addition to the existing SVT.

If the new SVT is stored in addition to the old SVT, it SHOULD be stored in a new &lt;ds:SignatureProperty&gt; element inside the existing &lt;ds:SignatureProperties&gt; element where the old SVT is located.

For interoperability robustness, signature validation applications MUST be able to handle signatures where the new SVT is located in a new &lt;ds:Object&gt; element.


# SVT Claims {#svt-claims}

## Signature Reference Data {#signature-reference-data}

The SVT Signature object MUST contain a "sig_ref" claim (SigReference object) with the following elements:

- "id" -- The Id-attribute of the XML signature, if present.

- "sig_hash" -- The hash over the signature value bytes.

- "sb_hash" -- The hash over the canonicalized &lt;ds:SignedInfo&gt; element (the bytes the XML signature algorithm has signed to generated the signature value).


## Signed Data Reference Data {#signed-data-reference}

The SVT Signature object MUST contain one instance of the "sig_data" claim (SignedData object) for each &lt;ds:Reference&gt; element in the &lt;ds:SignedInfo&gt; element. The "sig_data" claim MUST contain the following elements:

- "ref" -- The value of the URI attribute of the corresponding &lt;ds:Reference&gt; element.

- "hash" -- The hash of all bytes identified corresponding &lt;ds:Reference&gt; element after applying all identified canonicalization and transformation algorithms. These are the same bytes that is hashed by the hash value in the &lt;ds:DigestValue&gt; element inside the &lt;ds:Reference&gt; element.

## Signer Certificate References {#signer-certificate-references}

The SVT Signature object MUST contain a "signer_cert_ref" claim (CertReference object). The "type" parameter of the "signer_cert_ref" claim MUST be either "chain" or "chain_hash".

- The "chain" type MUST be used when signature validation was performed using one or more certificates where some or all of the certificates in the chain are not present in the target signature.
- The "chain_hash" type MUST be used when signature validation was performed using one or more certificates where all of the certificates are present in the target signature.

# JOSE Header {#jose-header}

## SVT Signing Key Reference {#svt-signing-key-reference}

The SVT JOSE header must contain one of the following header parameters in accordance with {{RFC7515}}, for storing a reference to the public key used to verify the signature on the SVT:

- "x5c" -- Holds an X.509 certificate {{RFC5280}} or a chain of certificates. The certificate holding the public key that verifies the signature on the SVT MUST be the first certificate in the chain.
- "kid" -- A key identifier holding the Base64 encoded hash value of the certificate that can verify the signature on the SVT. The hash algorithm MUST be the same hash algorithm used when signing the SVT as specified by the `alg` header parameter.
