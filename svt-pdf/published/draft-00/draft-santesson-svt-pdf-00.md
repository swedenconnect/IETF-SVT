---
title: Signature Validation Token
docname: draft-santesson-svt-pdf-00
date: 2020-10-21
category: std
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
  RFC3161:
  RFC5280:
  RFC5035:
  RFC7515:
  RFC8174:
  ISOPDF2:
    title: "Document management -- Portable document format -- Part 2: PDF 2.0"
    author:
      org: ISO
    date: 2017-07
    seriesinfo:
      "ISO": "32000-2"
  PADES:
    title: "Electronic Signatures and Infrastructures (ESI); PAdES digital signatures; Part 1: Building blocks and PAdES baseline signatures"
    author:
      org: ETSI
    date: 2016-04
    seriesinfo:
      "ETSI": "EN 319 142-1 v1.1.1"
  SVT:
    title: "Signature Validation Token"
    author:
    -
      ins: S. Santesson
      name: Stefan Santesson
    -
      ins: R. Housley
      name: Russ Housley
    date: 2020-10
    seriesinfo:
      "IETF": "draft-santesson-svt-00"

--- abstract

This document defines a PDF profile for the Signature Validation Token defined in {{SVT}}.

--- middle

# Introduction {#intro}

The "Signature Validation Token" specification {{SVT}} defines a basic token to support signature validation in a way that can significantly extend the lifetime of a signature.

This specification defines a profile for implementing SVT with a signed PDF document, and defines the following aspects of SVT usage:

- How to include reference data related to PDF signatures and PDF documents in an SVT.
- How to add an SVT token to a PDF document.

PDF document signatures are added as incremental updates to the signed PDF document and signs all data of the PDF document up until the current signature. When more than one signature is added to a PDF document the previous signature is signed by the next signature and can not be updated with additional data after this event.

To minimize the impact on PDF documents with multiple signatures and to stay backwards compatible with PDF software that do not understand SVT, PDF documents add one SVT token for all signatures of the PDF as an extension to a document timestamp added to the signed PDF as an incremental update. This SVT covers all signatures of the signed SVT.


# Definitions {#defs}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in BCP&nbsp;14 {{RFC2119}} {{RFC8174}}
when, and only when, they appear in all capitals, as shown here.

The definitions in {{SVT}} apply also to this document.

# SVT in PDF Documents {#svt-in-pdf}

An SVT added to a signed PDF document SHALL be added to a document timestamp accordance with ISO 32000-2:2017 {{ISOPDF2}}.

The document timestamp contains an {{RFC3161}} timestamp token (TSTInfo) in EncapsulatedContentInfo of the CMS signature. The SVT SHALL be added to the timestamp token (TSTInfo) as an Extension object as defined in  {{svt-extension-to-timestamps}}.

## SVT Extension to Timestamp Tokens {#svt-extension-to-timestamps}

The SVT extension is an Extension suitable to be included in TSTInfo as defined by {{RFC3161}}.

The SVT extension is identified by the Object Identifier (OID) 1.2.752.201.5.2

Editors note: This is the current used OID. Consider assigning an IETF extension OID.

This extension data (OCTET STRING) holds the bytes of SVT JWT, represented as a UTF-8 encoded string.

This extension SHALL NOT be marked critical.

Note: Extensions in timestamp tokens according to {{RFC3161}} are imported from the definition of the X.509 certificate extensions defined in {{RFC5280}}.

# SVT Claims {#svt-claims}

## Signature Reference Data {#signature-reference-data}

The SVT SHALL contain a SigReference claims object that SHALL contain the following data:

- id -- Absent or a Null value.

- sig_hash -- The hash over the signature value bytes.

- sb_hash -- The hash over the DER encoded SignedAttributes in SignerInfo.


## Signed Data Reference Data {#signed-data-reference}

An SVT according to this profile SHALL contain exactly one instance of the **SignedData** claims object. The **SignedData** claims object shall contain the following data:

- ref -- The string representation of the ByteRange value of the PDF signature dictionary of the target signature. This is a sequence of integers separated by space where each integer pair specifies the start index and length of a byte range.

- hash -- The hash of all bytes identified by the ByteRange value. This is the concatenation of all byte ranges identified by the ByteRange value.

## Signer Certificate References {#signer-certificate-references}

The SVT SHALL contain a CertReference claims object. The type claim of the CertReference claims object SHALL be either chain or chain_hash`.

- The chain type SHALL be used when signature validation was performed using one or more certificates where some or all of the certificates in the chain are not present in the target signature.
- The chain_hash type SHALL be used when signature validation was performed using one or more certificates where all of the certificates are present in the target signature.

Note: The referenced signer certificate MUST match any certificates referenced using ESSCertID or ESSCertIDv2 from {{RFC5035}}.

# JOSE Header {#jose-header}

## SVT Signing Key Reference {#svt-signing-key-reference}

The SVT JOSE header must contain one of the following header parameters in accordance with {{RFC7515}}, for storing a reference to the public key used to verify the signature on the SVT:

- x5c -- Holds an X.509 certificate {{RFC5280}} or a chain of certificates. The certificate holding the public key that verifies the signature on the SVT MUST be the first certificate in the chain.
- kid -- A key identifier holding the Base64 encoded hash value of the certificate that can verify the signature on the SVT. The hash algorithm MUST be the same hash algorithm used when signing the SVT as specified by the `alg` header parameter. The referenced certificate SHOULD be the same certificate that was used to sign the document timestamp that contains the SVT.
