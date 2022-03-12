---
title: Signature Validation Token
docname: draft-santesson-svt-03
date: 2022-03-11
category: info
submissionType: independent

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
  RFC8174:
  RFC5280:
  RFC5652:
  RFC6931:
  RFC7515:
  RFC7518:
  RFC7519:
  ETSI319102-1:
    title: "ETSI - Electronic Signatures and Infrastructures (ESI); Procedures for Creation and Validation of AdES Digital Signatures; Part 1: Creation and Validation"
    author:
      org: ETSI
    date: 2016-05
    seriesinfo:
      "ETSI": "EN 319 102-1 v1.1.1"
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
  ISOPDF2:
    title: "Document management -- Portable document format -- Part 2: PDF 2.0"
    author:
      org: ISO
    date: 2017-07
    seriesinfo:
      "ISO": "32000-2"
  XADES:
    title: "Electronic Signatures and Infrastructures (ESI); XAdES digital signatures; Part 1: Building blocks and XAdES baseline signatures"
    author:
      org: ETSI
    date: 2016-04
    seriesinfo:
      "ETSI": "EN 319 132-1 v1.1.1"
  PADES:
    title: "Electronic Signatures and Infrastructures (ESI); PAdES digital signatures; Part 1: Building blocks and PAdES baseline signatures"
    author:
      org: ETSI
    date: 2016-04
    seriesinfo:
      "ETSI": "EN 319 142-1 v1.1.1"
  CADES:
    title: "Electronic Signatures and Infrastructures (ESI); CAdES digital signatures; Part 1: Building blocks and CAdES baseline signatures"
    author:
      org: ETSI
    date: 2016-04
    seriesinfo:
      "ETSI": "EN 319 122-1 v1.1.1"

informative:
  RFC8610:

--- abstract

Electronic signatures have a limited lifespan with respect to the time period that they
can be validated and determined to be authentic. The Signature Validation Token (SVT)
defined in this specification provides evidence that asserts the validity of an
electronic signature. The SVT is provided by a trusted authority, which asserts that
a particular signature was successfully validated according to defined procedures at
a certain time. Any future validation of that electronic signature can be satisfied by
validating the SVT without any need to also validate the original electronic signature or
the associated digital certificates. SVT supports electronic signatures in CMS, XML, and
PDF documents.

--- middle

# Introduction {#intro}

Electronic signatures have a limited lifespan regarding when they can be validated
and determined to be authentic. Many factors make it more difficult to validate
electronic signatures over time. For example:

- Trusted information about the validity of the certificate containing the signer's public key is not available.
- Trusted information about the date and time when the signature was actually created is not available.
- Algorithms used to create the electronic signature are no longer considered secure.
- Services necessary to validate the signature are no longer available.
- Supporting evidence such as CA certificates, OCSP responses, CRLs, or timestamps.

The challenges to validation of an electronic signature increases over time, and
eventually it is simply impossible to verify the signature with a sufficient level of
assurance.

Existing standards, such as the ETSI XAdES {{XADES}} profile for XML
signatures {{XMLDSIG11}}, ETSI PAdES {{PADES}} profile for PDF signatures
{{ISOPDF2}}, and ETSI CAdES {{CADES}} profile for CMS signatures
{{RFC5652}} can be used to prolong the lifetime of a signature by
storing data that supports validation of the electronic signature beyond
the lifetime of the certificate containing the signer's public key, which
is often referred to as the signing certificate.  The problem with this
approach is that the amount of information that must be stored along with
the electronic signature constantly grows over time.  The increasing
amount of information and signed objects that need to be validated in
order to verify the original electronic signature grows in complexity to
the point where validation of the electronic signature may become
infeasible.

The Signature Validation Token (SVT) defined in this specification takes a fundamentally
different approach to the problem by providing evidence by a trusted authority that
asserts the validity of an electronic signature. The SVT asserts that a particular
electronic signature was successfully validated  by a trusted authority according to
defined procedures at a certain date and time. Once the SVT is issued by a trusted
authority, any future validation of that electronic signature is satisfied by validating
the SVT, without any need to also validate the original electronic signature.

This approach drastically reduces the complexity of validation of older electronic
signatures for the simple reason that validating the SVT eliminates the need to
validate the many signed objects that would otherwise been needed to provide the
same level of assurance. The SVT can be signed with private keys and algorithms that
provide confidence for a considerable time period. In fact, multiple SVTs can be used
to offer greater assurance. For example, one SVT could be produced with a large RSA
private key, a second one with a strong elliptic curve, and a third one with a quantum
safe digital signature algorithm to protect against advances in computing power and
cryptanalytic capabilities. Further, the trusted authority can add additional SVTs
in the future using fresh private keys and signatures to extend the lifetime of the,
if necessary.

# Definitions {#defs}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in BCP&nbsp;14 {{RFC2119}} {{RFC8174}}
when, and only when, they appear in all capitals, as shown here.

This document use the following terms:

- Signed Data -- The data covered by a particular electronic signature. This is typically
equivalent to the signed content of a document, and it represents the data that the
signer intended to sign. In some cases, such as in some XML signatures, the signed data
can be the collection of several data fragments each referenced by the signature. In the
case of PDF, this is the data covered by the "ByteRange" parameter in the signature
dictionary.

- Signed Bytes -- These are the actual bytes of data that were hashed and signed by the
digital signature algorithm. In most cases, this is not the actual Signed Data, but a
collection of signature metadata that includes references (hash) of the Signed Data as
well as information about algorithms and other data bound to a signature. In XML, this
is the canonicalized SignedInfo element. In CMS and PDF signatures, this is the
DER-encoded SignedAttributes structure.

When these terms are used as defined in this section, they appear with a
capitalized first letter.

# Signature Validation Token {#svt}

The Signature Validation Token (SVT) is created by a trusted service to capture
evidence of successful electronic signature verification, and then relying
parties can depend on the checking that has already taken place by the
trusted service.

## Signature Validation Token Function {#svt-function}

The function of the SVT is to capture evidence of electronic signature
validity at one instance of secure signature validation process and to
use that evidence to eliminate the need to perform any repeated
cryptographic validation of the original electronic signature value, as
well as reliance on any hash values bound to that signature.  The SVT
achieves this by binding the following information to a specific
electronic signature:

- A unique identification of the electronic signature.

- The data and metadata signed by the electronic signature.

- The signer's certificate that was validated as part of electronic signature verification.

- The certification path that was used to validate the signer's certificate.

- An assertion providing evidence of that the signature was verified, the date and time the verification was performed, the procedures used to verify the electronic signature, and the outcome of the verification.

- An assertion providing evidence of the date and time at which the signature is known to have existed, the procedures used to validate the date and time of existence, and the outcome of the validation.

Using an SVT is equivalent to validating a signed document in a system once, and then
using that document multiple times without subsequent revalidating the electronic
signature for each usage. Such procedures are common in systems where the document is
residing in a safe and trusted environment where it is protected against modification. The
SVT allows the safe and trusted environment to expand beyond a locally controlled
environment, and the SVT allows a greater period between original electronic signature
verification and subsequent usage.

Using the SVT, the electronic signature verification of a document can be take place
once using a reliable trusted service, and then any relying party that is able to
depend on the verification process already performed by the trusted service. The SVT
is therefore not only a valuable tool to extend the lifetime of a signed document, but
also avoids the need for careful integration between electronic signature verification
and document usage.

## Signature Validation Token Syntax {#svt-syntax}

The SVT is carried in a JSON Web Token (JWT) as defined in {{RFC7519}}.

### Data Types {#svt-syntax-dt}

The contents of claims in an SVT are specified using the following data types:

- String -- JSON Data Type of string that contains an arbitrary case sensitive string value.

- Base64Binary -- JSON Data Type of string that contains of Base64 encoded byte array of binary data.

- StringOrURI -- JSON Data Type of string that contains an arbitrary string or an URI as defined in {{RFC7519}}, which REQUIRES a value containing the colon character (":") to be a URI.

- URI -- JSON Data Type of string that contains an URI as defined in {{RFC7519}}.

- Integer -- JSON Data Type of number that contains a 32-bit signed integer value (from -2^31 to 2^31-1).

- Long -- JSON Data Type of number that contains a 64-bit signed integer value (from -2^63 to 2^63-1).

- NumericDate -- JSON Data Type of number that contains a data as defined in {{RFC7519}}, which is the number of seconds from 1970-01-01T00:00:00Z UTC until the specified UTC date/time, ignoring leap seconds.

- Boolean -- JSON Data Type of boolean that contains explicit value of true or false.

- Object&lt;Class&gt; -- A JSON object holding a claims object of a class defined in this specification (see {{svt-syntax-claim}}).

- Map&lt;Type&gt; -- A JSON object with name-value pairs where the value is an object of the specified Type in the notation. For example, Map&lt;String&gt; is a JSON object with name value pairs where all values are of type String.

- Array -- A JSON array of a specific data type as defined in this section. An array is expressed in this specification by square brackets. For example, \[String\] indicates an array of String values, and \[Object&lt;DocHash&gt;\] indicates an array of DocHash objects.

- Null -- A JSON null that represents an absent value. A claim with a null value is equivalent with an absent claim.

### Signature Validation Token JWT Claims {#svt-syntax-claim}

The SVT MUST contain only JWT claims in the following list:

- jti -- A String data type that is a "JWT ID" registered claim according to {{RFC7519}}. It is RECOMMENDED that the identifier holds a hexadecimal string representation of a 128-bit unsigned integer. A SVT MUST contain one "JWT ID" claim.

- iss  -- A StringOrURI data type that is an "Issuer" registered claim according to {{RFC7519}}, which is an arbitrary unique identifier of the SVT issuer. This value SHOULD have the value of an URI based on a domain owned by the issuer. A SVT MUST contain one "Issuer" claim.

- iat -- A NumericDate data type that is an "Issued At" registered claim according to {{RFC7519}}, which expresses the date and time when this SVT was issued. A SVT MUST contain one "Issued At" claim.

- aud -- A \[StringOrURI\] data type or a StringOrURI data type that is an "Audience" registered claim according to {{RFC7519}}. The audience claim is an array of one or more identifiers, identifying intended recipients of the SVT. Each identifier MAY identify a single entity, a group of entities or a common policy adopted by a group of entities. If only one value is provided it MAY be provided as a single StringOrURI data type value instead of as an array of values. Inclusion of the "Audience" claim in a SVT is OPTIONAL.

- exp -- A NumericDate data type that is an "Expiration Time" registered claim according to {{RFC7519}}, which expresses the date and time when services and responsibilities related to this SVT is no longer provided by the SVT issuer. The precise meaning of the expiration time claim is defined by local policies. See implementation note below. Inclusion of the "Expiration Time" claim in a SVT is OPTIONAL.

- sig_val_claims -- A Object&lt;SigValidation&gt; data type that contains signature validation claims for this SVT extending the standard registered JTW claims above. A SVT MUST contain one sig_val_claims claim.

Note: An SVT asserts that a particular validation process was undertaken at a stated
date and time. This fact never changes and never expires. However, some other aspects
of the SVT such as liability for false claims or service provision related to a specific
SVT may expire after a certain period of time, such as a service where an old SVT can be
upgraded to a new SVT signed with fresh keys and algorithms.

### SigValidation Object Class {#sigvalidation-obj-class}

The sig_val_claims JWT claim uses the SigValidation object class. A SigValidation object
holds all custom claims, and a SigValidation object contains the following parameters:

- ver -- A String data type representing the version. This parameter MUST be present, and the version in this specification indicated by the value "1.0".

- profile -- A StringOrURI data type representing the name of a profile that defines conventions followed for specific claims and any extension points used by the SVT issuer. Inclusion of this parameter is OPTIONAL.

- hash_algo -- A URI data type that identifies the hash algorithm used to compute the hash values within the SVT. The URI identifier MUST be one defined in {{RFC6931}} or in the IANA registry defined by this specification. This parameter MUST be present.

- sig -- A \[Object&lt;Signature&gt;\] data type that gives information about validated electronic signatures as an array of Signature objects. If the SVT contains signature validation evidence for more than one signature, then each signature is represented by a separate Signature object. At least one Signature object MUST be present.

- ext -- A Map&lt;String&gt; data type that provides additional claims related to the SVT. Extension claims are added at the discretion of the SVT issuer; however, extension claims MUST follow any conventions defined in a profile of this specification (see {{profiles}}). Inclusion of this parameter is OPTIONAL.

### Signature Claims Object Class {#signature-obj-class}

The sig parameter in the SigValidation object class uses the Signature object
class. The Signature object contains claims related to signature validation
evidence for one signature, and it contains the following parameters:

- sig_ref -- A Object&lt;SigReference&gt; data type that contains reference information identifying the target signature. This parameter MUST be present.

- sig_data_ref -- A \[Object&lt;SignedData&gt;\] data type that contains an array of references to Signed Data that was signed by the target electronic signature.  This parameter MUST be present.

- signer_cert_ref -- A Object&lt;CertReference&gt; data type that references the signer's certificate and optionally reference to a supporting certification path that was used to verify the target electronic signature. This parameter MUST be present.

- sig_val -- A \[Object&lt;PolicyValidation&gt;\] data type that contains an array of results of signature verification according to defined procedures. This parameter MUST be present.

- time_val -- A \[Object&lt;TimeValidation&gt;\] data type that contains an array of time verification results that the target signature has existed at a specific date and time in the past. Inclusion of this parameter is OPTIONAL.

- ext -- A MAP&lt;String&gt; data type that provides additional claims related to the target signature. Extension claims are added at the discretion of the SVT Issuer; however, extension claims MUST follow any conventions defined in a profile of this specification (see {{profiles}}). Inclusion of this parameter is OPTIONAL.

### SigReference Claims Object Class {#sigreference-obj-class}

The sig_ref parameter in the Signature object class uses the SigReference object
class. The SigReference object provides information used to match the Signature
claims object to a specific target electronic signature and to verify the integrity
of the target signature value and Signed Bytes, and it contains the following parameters:

- id -- A String data type that contains an identifier assigned to the target signature. Inclusion of this parameter is OPTIONAL.

- sig_hash -- A Base64Binary data type that contains a hash value of the target electronic signature value. This parameter MUST be present.

- sb_hash -- A Base64Binary data type that contains a hash value of the Signed Bytes of the target electronic signature. This parameter MUST be present.

### SignedData Claims Object Class {#signeddata-obj-class}

The sig_data_ref parameter in the Signature object class uses the SignedData object
class. The SignedData object provides information used to verify the target electronic
signature references to Signed Data as well as to verify the integrity of all data that
is signed by the target signature, and it contains the following parameters:

- ref -- A String data type that contains a reference identifier for the data or data fragment covered by the target electronic signature. This parameter MUST be present.

- hash -- A Base64Binary data type that contains the hash value for the data covered by the target electronic signature. This parameter MUST be present.

### PolicyValidation Claims Object Class {#policyval-obj-class}

The sig_val parameter in the Signature object class uses the PolicyValidation object
class. The PolicyValidation object provides information about the result of a validation
process according to a spefific policy, and it contains the following parameters:

- pol -- A StringOrURI data type that contains the identifier of the policy governing the electronic signature verification process. This parameter MUST be present.

- res -- A String data type that contains the result of the electronic signature verification process. The value MUST be one of "PASSED", "FAILED" or "INDETERMINATE" as defined by {{ETSI319102-1}}. This parameter MUST be present.

- msg -- A String data type that contains a message describing the result. Inclusion of this parameter is OPTIONAL.

- ext -- A MAP&lt;String&gt; data type that provides additional claims related to the target signature. Extension claims are added at the discretion of the SVT Issuer; however, extension claims MUST follow any conventions defined in a profile of this specification (see {{profiles}}). Inclusion of this parameter is OPTIONAL.

### TimeValidation Claims Object Class {#timever-obj-class}

The time_val parameter in the Signature object class uses the TimeValidation object
class. The TimeValidation claims object provides information about the result of
validating time evidence asserting that the target signature existed at a particular
date and time in the past, and it contains the following parameters:

- time -- A NumericDate data type that contains the verified time. This parameter MUST be present.

- type -- A StringOrURI data type that contains an identifier of the type of evidence of time. This parameter MUST be present.

- iss -- A StringOrURI data type that contains an identifier of the entity that issued the evidence of time. This parameter MUST be present.

- id -- A String data type that contains an unique identifier assigned to the evidence of time.  Inclusion of this parameter is OPTIONAL.

- val -- A \[Object&lt;PolicyValidation&gt;\] data type that contains an array of results of the time evidence validation according to defined validation procedures. Inclusion of this parameter is OPTIONAL.

- ext -- A MAP&lt;String&gt; data type that provides additional claims related to the target signature. Extension claims are added at the discretion of the SVT Issuer; however, extension claims MUST follow any conventions defined in a profile of this specification (see {{profiles}}). Inclusion of this parameter is OPTIONAL.

### CertReference Claims Object Class {#certref-obj-class}

The signer_cert_ref parameter in the Signature object class uses the CertReference object
class. The CertReference object references a single X.509 certificate or a X.509
certification path, either by providing the certificate data or by providing hash
references for certificates that can be located in the target electronic signature, and
it contains the following parameters:

- type -- A StringOrURI data type that contains an identifier of the type of reference. The type identifier MUST be one of the identifiers defined below, an identifier specified by the selected profile, or a URI identifier. This parameter MUST be present.

- ref -- A \[String\] data type that contains an array of string parameters according to conventions defined by the type identifier. This parameter MUST be present.

The following type identifiers are defined:

- chain -- The ref contains an array of Base64 encoded X.509 certificates {{RFC5280}}. The certificates MUST be provided in the order starting with the end entity certificate. Any following certificate must be able to validate the signature on the previous certificate in the array.

- chain_hash -- The ref contains an array of one or more Base64 encoded hash values where each hash value is a hash over a X.509 certificate {{RFC5280}} used to validate the signature.  The certificates MUST be provided in the order starting with the end entity certificate.  Any following certificate must be able to validate the signature on the previous certificate in the array. This option MUST NOT be used unless all hashed certificates are present in the target electronic signature.

Note: All certificates referenced using the identifiers above are X.509 certificates.
Profiles of this specification MAY define alternative types of public key containers;
however, a major function of these referenced certificates is not just to reference
the public key, but also to provide the subject name of the signer. It is therefore
important for the full function of an SVT that the referenced public key container also
provides the means to identify of the signer.

### SVT JOSE Header {#svt-jose-header}

The SVT JWT MUST contain the following JOSE header parameters in accordance with
Section 5 of {{RFC7519}}:

- typ -- This parameter MUST have the string value "JWT" (upper case).

- alg -- This parameter identifies the algorithm used to sign the SVT JWT. The algorithm identifier MUST be specified in {{RFC7518}} or the IANA JSON Web Signature and Encryption Algorithms Registry \[ add a ref \]. The specified signature hash algorithm MUST be identical to the hash algorithm specified in the hash_algo parameter of the SigValidation object within the sig_val_claims claim.

The SVT header MUST contain a public key or a reference to a public key used to verify the signature on the SVT in accordance with {{RFC7515}}. Each profile, as discussed in {{profiles}}, MUST define the requirements for how the key or key reference is included in the header.

# Profiles {#profiles}

Each signed document and signature type will have to define the precise content and
use of several claims in the SVT.

Each profile MUST as a minimum define:

- How to reference the Signed Data content of the signed document.

- How to reference to the target electronic signature and the Signed Bytes of the signature.

- How to reference certificates supporting each electronic siganture.

- How to include public keys or references to public keys in the SVT.

- Whether each electronic signature is supported by a single SVT, or whether one SVT may support multiple electronic signatures of the same document.

A profile MAY also define:

- Explicit information on how to perform signature validation based on an SVT.

- How to attach an SVT to an electronic signature or signed document.

# Signature Verification with a SVT

Signature verification based on an a SVT MUST follow these steps:

1. Locate all available SVTs available for the signed document that are relevant for the target electronic signature.

2. Select the most recent SVT that can be successfully validated and meets the requirement of the relying party.

3. Verify the integrity of the signature and the Signed Bytes of the target electronic signature using the sig_ref claim.

4. Verify that the Signed Data reference in the original electronic signature matches the reference values in the sig_data_ref claim.

5. Verify the integrity of referenced Signed Data using provided hash values in the sig_data_ref claim.

6. Obtain the verified certificates supporting the asserted electronic signature verification through the signer_cert_ref claim.

7. Verify that signature validation policy results satisfy the requirements of the relying party.

8. Verify that verified time results satisfy the context for the use of the signed document.

After successfully performing these steps, signature validity is established as well as
the trusted signer certificate binding the identity of the signer to the electronic
signature.

# IANA Considerations {#iana}

## Claim Names Registration {#claim-names-reg}

This section registers the "sig_val_claims" claim name in the IANA "JSON Web Token Claims" registry established by Section 10.1 in {{RFC7519}}.

### Registry Contents {#clname-reg-contents}

  - Claim Name: "sig_val_claims"
  - Claim Description: Signature Validation Token
  - Change Controller: IESG
  - Specification Document(s): {{sigvalidation-obj-class}} of {this document}

NOTE to RFC editor: Please replace {this document} with its assigned RFC number.


# Security Considerations {#seccons}

## Level of reliance {#seccon-lvl-of-reliance}

An SVT allows a signature verifier to still validate the original signature using
the original signature data and to use the information in the SVT selectively to
either just confirm the validity and integrity of the original data, such as confirming the integrity of signed data or the validity of the signer's certificate etc.

Another way to use an SVT is to completely rely on the validation conclusion provided
by the SVT and to omit re-validation of the original signature value and original
certificate status checking data.

This choice is a decision made by the verifier according to its own policy and risk assessment.

However, even when relying on the SVT validation conclusion of an SVT it is vital to still verify that
the present SVT is correctly associated with the document and signature that is being validated by
validating the hashed reference data in the SVT of the signature, signing certificate chain,
signed data and the signed bytes.

## Aging algorithms {#seccon-aging-algos}

Even if the SVT provides protection against algorithms becoming weakened or broken over time, this protection is only valid for as long as the algorithms used to sign the SVT are still considered secure. It is advisable to re-issue SVT in cases where an algorithm protecting the SVT is getting close to its end of life.

One way to increase the resistance of algorithms becoming insecure, is to issue multiple SVT for the same signature with different algorithms and key lengths where one algorithm could still be secure even if the corresponding algorithm used in the alternative SVT is broken.

--- back

# Appendix: Schemas

## Concise Data Definition Language (CDDL)

The following informative CDDL {{RFC8610}} express the structure of an SVT token:

~~~
svt = {
  jti: text
  iss: text
  iat: uint
  ? aud: text / [* text]
  ? exp: uint
  sig_val_claims: SigValClaims
}

SigValClaims = {
  ver: text
  profile: text
  hash_algo: text
  sig: [+ Signature]
  ? ext: Extension
}

Signature = {
  sig_ref: SigReference
  sig_data_ref: [+ SignedData]
  signer_cert_ref: CertReference
  sig_val: [+ PolicyValidation]
  ? time_val: [+ TimeValidation]
  ? ext: Extension
}

SigReference = {
  ? id: text / null
  sig_hash: binary-value
  sb_hash: binary-value
}

SignedData = {
  ref: text
  hash: binary-value
}


CertReference = {
  type: "chain" / "chain_hash"
  ref: [+ text]
}

PolicyValidation = {
  pol: text
  res: "PASSED" / "FAILED" / "INDETERMINATE"
  ? msg: text / null
  ? ext: Extension
}

TimeValidation = {
  "time": uint
  type: text
  iss: text
  ? id: text / null
  ? val: [+ PolicyValidation]
  ? ext: Extension
}


Extension = {
  + text => text
} / null

binary-value = text      ; base64 classic with padding
~~~

## JSON Schema

The following informative JSON schema describes the syntax of the SVT token payload.

~~~
{
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "title": "Signature Validation Token JSON Schema",
    "description": "Schema defining the payload format for SVT",
    "type": "object",
    "required": [
        "jti",
        "iss",
        "iat",
        "sig_val_claims"
    ],
    "properties": {
        "jti": {
            "description": "JWT ID",
            "type": "string"
        },
        "iss": {
            "description": "Issuer",
            "type": "string"
        },
        "iat": {
            "description": "Issued At",
            "type": "integer"
        },
        "aud": {
            "description": "Audience",
            "type": [
                "string",
                "array"
            ],
            "items": {"type": "string"}
        },
        "exp": {
            "description": "Expiration time (seconds since epoch)",
            "type": "integer"
        },
        "sig_val_claims": {
            "description": "Signature validation claims",
            "type": "object",
            "required": [
                "ver",
                "profile",
                "hash_algo",
                "sig"
            ],
            "properties": {
                "ver": {
                    "description": "Version",
                    "type": "string"
                },
                "profile": {
                    "description": "Implementation profile",
                    "type": "string"
                },
                "hash_algo": {
                    "description": "Hash algorithm URI",
                    "type": "string"
                },
                "sig": {
                    "description": "Validated signatures",
                    "type": "array",
                    "items": {"$ref": "#/$def/Signature"}
                },
                "ext": {
                    "description": "Extension map",
                    "$ref": "#/$def/Extension"
                }
            },
            "additionalProperties": false
        }
    },
"additionalProperties": false,
"$def": {
         "Signature":{
             "type": "object",
             "required": [
                 "sig_ref",
                 "sig_data_ref",
                 "signer_cert_ref",
                 "sig_val"
             ],
             "properties": {
                 "sig_ref": {
                     "description": "Signature Reference",
                     "$ref": "#/$def/SigReference"
                 },
                 "sig_data_ref": {
                     "description": "Signed data array",
                     "type": "array",
                     "items": {
                         "$ref" : "#/$def/SignedData"
                     }
                 },
                 "signer_cert_ref": {
                     "description": "Signer certificate reference",
                     "$ref": "#/$def/CertReference"
                 },
                 "sig_val": {
                     "description": "Signature validation results",
                     "type": "array",
                     "items": {
                         "$ref": "#/$def/PolicyValidation"
                     }
                 },
                 "time_val": {
                     "description": "Time validations",
                     "type": "array",
                     "items": {
                         "$ref": "#/$def/TimeValidation"
                     }
                 },
                "ext": {
                    "description": "Extension map",
                    "$ref": "#/$def/Extension"
                }
             },
             "additionalProperties": false
         },
         "SigReference":{
             "type": "object",
             "required": [
                 "sig_hash",
                 "sb_hash"
             ],
             "properties": {
                 "sig_hash": {
                     "description": "Hash of the signature value",
                     "type": "string",
                     "format": "base64"
                 },
                 "sb_hash": {
                     "description": "Hash of the Signed Bytes",
                     "type": "string",
                     "format": "base64"
                 },
                 "id": {
                     "description": "Signature ID reference",
                     "type": ["string","null"]
                 }
             },
            "additionalProperties": false
         },
         "SignedData": {
             "type": "object",
             "required": [
                 "ref",
                 "hash"
             ],
             "properties": {
                 "ref": {
                     "description": "Reference to the signed data",
                     "type": "string"
                 },
                 "hash": {
                     "description": "Signed data hash",
                     "type": "string",
                     "format": "base64"
                 }
             },
            "additionalProperties": false
         },
         "CertReference":{
             "type": "object",
             "required": [
                 "type",
                 "ref"
             ],
             "properties": {
                 "type": {
                     "description": "Type of certificate reference",
                     "type": "string",
                     "enum": ["chain","chain_hash"]
                 },
                 "ref": {
                     "description": "Certificate reference data",
                     "type": "array",
                     "items": {
                         "type": "string",
                         "format": "base64"
                     }
                 }
             },
            "additionalProperties": false
         },
         "PolicyValidation":{
             "type": "object",
             "required": [
                 "pol",
                 "res"
             ],
             "properties": {
                 "pol": {
                     "description": "Policy identifier",
                     "type": "string"
                 },
                 "res": {
                     "description": "Signature validation result",
                     "type": "string",
                     "enum": ["PASSED","FAILED","INDETERMINATE"]
                 },
                 "msg": {
                     "description": "Message",
                     "type": ["string","null"]
                 },
                 "ext": {
                    "description": "Extension map",
                    "$ref": "#/$def/Extension"
                }
             },
            "additionalProperties": false
         },
         "TimeValidation":{
             "type": "object",
             "required": [
                 "time",
                 "type",
                 "iss"
             ],
             "properties": {
                 "time": {
                     "description": "Verified time",
                     "type": "integer"
                 },
                 "type": {
                     "description": "Type of time validation proof",
                     "type": "string"
                 },
                 "iss": {
                     "description": "Issuer of the time proof",
                     "type": "string"
                 },
                 "id": {
                     "description": "Tiem evidence identifier",
                     "type": ["string","null"]

                 },
                 "val": {
                     "description": "Validation result",
                     "type": "array",
                     "items": {
                         "$ref": "#/$def/PolicyValidation"
                     }
                 },
                 "ext": {
                    "description": "Extension map",
                    "$ref": "#/$def/Extension"
                }
             },
            "additionalProperties": false
         },
         "Extension": {
           "description": "Extension map",
           "type": ["object","null"],
           "required": [],
           "additionalProperties": {
               "type": "string"
           }
         }
     }
}
~~~

# Appendix: Examples

The following example illustrates a basic SVT according to this specification
issued for a signed PDF document.

Note: Line breaks in the decoded example are inserted for readablilty. Line
breaks are not allowed in valid JSON data.

Signature validation token JWT:

~~~
eyJraWQiOiJPZW5JKzQzNEpoYnZmRG50ZlZcLzhyT3hHN0ZrdnlqYUtWSmFWcUlG
QlhvaFZoQWU1Zks4YW5vdjFTNjg4cjdLYmFsK2Z2cGFIMWo4aWJnNTJRQnkxUFE9
PSIsInR5cCI6IkpXVCIsImFsZyI6IlJTNTEyIn0.eyJhdWQiOiJodHRwOlwvXC9l
eGFtcGxlLmNvbVwvYXVkaWVuY2UxIiwiaXNzIjoiaHR0cHM6XC9cL3N3ZWRlbmNv
bm5lY3Quc2VcL3ZhbGlkYXRvciIsImlhdCI6MTYwMzQ1ODQyMSwianRpIjoiNGQx
Mzk2ZjFmZjcyOGY0MGQ1MjQwM2I2MWM1NzQ0ODYiLCJzaWdfdmFsX2NsYWltcyI6
eyJzaWciOlt7ImV4dCI6bnVsbCwic2lnX3ZhbCI6W3sibXNnIjoiT0siLCJleHQi
Om51bGwsInJlcyI6IlBBU1NFRCIsInBvbCI6Imh0dHA6XC9cL2lkLnN3ZWRlbmNv
bm5lY3Quc2VcL3N2dFwvc2lndmFsLXBvbGljeVwvdHMtcGtpeFwvMDEifV0sInNp
Z19yZWYiOnsic2lnX2hhc2giOiJ5Y2VQVkxJemRjcEs5N0lZT2hGSWYxbnk3OUht
SUNiU1Z6SWVaTmJpem83ckdJd0hOTjB6WElTeUtHakN2bm9uT2FRR2ZMXC9QM3ZE
dEI4OHlLU1dlWGc9PSIsImlkIjoiaWQtNzM5ODljNmZjMDYzNjM2YWI1ZTc1M2Yx
MGY3NTc0NjciLCJzYl9oYXNoIjoiQm9QVjRXQ0E5c0FJYWhqSzFIYWpmRnhpK0F6
QzRKR1R1ZjM5VzNaV2pjekRDVVJ4ZGM5WWV0ZUh0Y3hHVmVnZ3B4SEo3NVwvY1E3
SE4xZERkbGl5SXdnPT0ifSwic2lnbmVyX2NlcnRfcmVmIjp7InJlZiI6WyIxK2Fh
SmV0ZzdyZWxFUmxVRFlFaVU0WklaaFQ0UlV2aUlRWnVLN28xR0ZLYVRQUTZ5K2t4
XC9QTnREcnB1cVE2WGZya0g5d1lESzRleTB5NFdyTkVybnc9PSIsImg0UER4YjVa
S214MWVUU3F2VnZZRzhnMzNzMDVKendCK05nRUhGVTRnYzl0cUcwa2dIa2Y2VzNv
THprVHd3dXJJaDZZOUFhZlpZcWMyelAycEUycDRRPT0iLCJEZDJDNXNCMElPUWVN
Vm5FQmtNNVE5Vzk2bUJITnd3YTJ0elhNcytMd3VZY09VdlBrcnlHUjBhUEc4Tzlu
SVAzbGJ3NktqUTFoRG1SazZ6Qzh4MmpkZz09Il0sInR5cGUiOiJjaGFpbl9oYXNo
In0sInNpZ19kYXRhX3JlZiI6W3sicmVmIjoiIiwiaGFzaCI6IkZjR3BPT2Y4aWxj
UHQyMUdEZDJjR25MR0R4UlM1ajdzdk00YXBwMkg0MWRERUxtMkN6Y2VUWTAybmRl
SmZXamludG1RMzc2SWxYVE9BcjMxeXpZenNnPT0ifSx7InJlZiI6IiN4YWRlcy0x
MWExNTVkOTJiZjU1Nzc0NjEzYmI3YjY2MTQ3N2NmZCIsImhhc2giOiJLUmtnYlo2
UFwvbmhVNjNJTWswR2lVZlVcL0RUd3ZlWWl0ZVFrd0dlSnFDNUJ6VE5WOGJRYnBl
ZFRUdVdKUHhxdkowUlk4NGh3bTdlWVwvZzBIckFPZWdLdz09In1dLCJ0aW1lX3Zh
bCI6W119XSwiZXh0IjpudWxsLCJ2ZXIiOiIxLjAiLCJwcm9maWxlIjoiWE1MIiwi
aGFzaF9hbGdvIjoiaHR0cDpcL1wvd3d3LnczLm9yZ1wvMjAwMVwvMDRcL3htbGVu
YyNzaGE1MTIifX0.TdHCoIUSZj2zMINKg7E44-8VE_mJq6TG1OoPwnYSs_hyUbuX
mrLJpuk8GR5YrndeOucPUYAwPxHt_f68JIQyFTi0agO9VJjn1R7Pj3Jt6WG9pYVN
n5LH-D1maxD11ZxxbcYeHbsstd2Sy2uMa3BdpsstGdPymSmc6GxY5uJoL0-5vwo_
3l-4Bb3LCTiuxYPcmztKIbDy2hEgJ3Hx1K4HF0SHgn3InpqBev3hm2SLw3hH5BCM
rywBAhHYE6OGE0aOJ6ktA5UP0jIIHfaw9i1wIiJtHTaGuvtyWSLk5cshmun9Hkdk
kRTA75bzuq0Iyd0qh070rA8Gje-s4Tw4xzttgKx1KSkvy8n5FqvzWdsZvclCG2mY
Y9rMxh_7607NXcxajAP4yDOoKNs5nm937ULe0vCN8a7WTrFuiaGjry7HhzRM4C5A
qxbDOBXPLyoMr4qn4LRJCHxOeLZ6o3ugvDOOWsyjk3eliyBwDu8qJH7UmyicLxDc
Cr0hUK_kvREqjD2Z
~~~

Decoded JWT Header:

~~~
{
  "kid":"OenI+434JhbvfDntfV\/8rOxG7FkvyjaKVJaVqIFBXohVhAe5fK8anov
         1S688r7Kbal+fvpaH1j8ibg52QBy1PQ==",
  "typ":"JWT",
  "alg":"RS512"
}
~~~

Decoded JWT Claims:

~~~
{
  "aud" : "http://example.com/audience1",
  "iss" : "https://swedenconnect.se/validator",
  "iat" : 1603458421,
  "jti" : "4d1396f1ff728f40d52403b61c574486",
  "sig_val_claims" : {
    "sig" : [ {
      "ext" : null,
      "sig_val" : [ {
        "msg" : "OK",
        "ext" : null,
        "res" : "PASSED",
        "pol" : "http://id.swedenconnect.se/svt/sigval-policy/
                 ts-pkix/01"
      } ],
      "sig_ref" : {
        "sig_hash" : "ycePVLIzdcpK97IYOhFIf1ny79HmICbSVzIeZNbizo7rGIw
                      HNN0zXISyKGjCvnonOaQGfL/P3vDtB88yKSWeXg==",
        "id" : "id-73989c6fc063636ab5e753f10f757467",
        "sb_hash" : "BoPV4WCA9sAIahjK1HajfFxi+AzC4JGTuf39W3ZWjczDCURx
                     dc9YeteHtcxGVeggpxHJ75/cQ7HN1dDdliyIwg=="
      },
      "signer_cert_ref" : {
        "ref" : [ "1+aaJetg7relERlUDYEiU4ZIZhT4RUviIQZuK7o1GFKaTPQ6y+
                   kx/PNtDrpuqQ6XfrkH9wYDK4ey0y4WrNErnw==",
                  "h4PDxb5ZKmx1eTSqvVvYG8g33s05JzwB+NgEHFU4gc9tqG0kgH
                   kf6W3oLzkTwwurIh6Y9AafZYqc2zP2pE2p4Q==",
                  "Dd2C5sB0IOQeMVnEBkM5Q9W96mBHNwwa2tzXMs+LwuYcOUvPkr
                   yGR0aPG8O9nIP3lbw6KjQ1hDmRk6zC8x2jdg==" ],
        "type" : "chain_hash"
      },
      "sig_data_ref" : [ {
        "ref" : "",
        "hash" : "FcGpOOf8ilcPt21GDd2cGnLGDxRS5j7svM4app2H41dDELm2Czc
                  eTY02ndeJfWjintmQ376IlXTOAr31yzYzsg=="
      }, {
        "ref" : "#xades-11a155d92bf55774613bb7b661477cfd",
        "hash" : "KRkgbZ6P/nhU63IMk0GiUfU/DTwveYiteQkwGeJqC5BzTNV8bQb
                  pedTTuWJPxqvJ0RY84hwm7eY/g0HrAOegKw=="
      } ],
      "time_val" : [ ]
    } ],
    "ext" : null,
    "ver" : "1.0",
    "profile" : "XML",
    "hash_algo" : "http://www.w3.org/2001/04/xmlenc#sha512"
  }
}
~~~
