
Signature Validation Token (SVT) Draft Specifications
=============================

This is the working area for the [TBD Working Group]() draft of [Signature Validation Token]

Current working draft for SVT specifications are located in the folders:

- **svt-main** for the main protocol
- **svt-xml** for the XML profile
- **svt-pdf** for the PDF profile

The latest compiled versions of each draft are located in the this root directory.

Note: That the latest working version found here normally is a later version than the last version submitted to the IETF.

**Latest drafts submitted to the IETF:**

- [https://datatracker.ietf.org/doc/draft-santesson-svt/](https://datatracker.ietf.org/doc/draft-santesson-svt/?include_text=1)
- [https://datatracker.ietf.org/doc/draft-santesson-svt-pdf/](https://datatracker.ietf.org/doc/draft-santesson-svt-pdf/)
- [https://datatracker.ietf.org/doc/draft-santesson-svt-xml/](https://datatracker.ietf.org/doc/draft-santesson-svt-xml/)

## Open source and reference implementation
Implementation of version 1.0 of this specification is available as open source. This open source is free to use under the Apache 2.0 license.

Repo | Description
---|---
[https://github.com/idsec-solutions/sig-validation-svt](https://github.com/idsec-solutions/sig-validation-svt) | ore components for generation and validation of Signature Validation Tokens
[https://github.com/idsec-solutions/sig-validation-base](https://github.com/idsec-solutions/sig-validation-base)  |  SVT enhanced signature validation and functions to extend XML and PDF documents with SVT tokens.

A reference implementation is available at: [https://sandbox.swedenconnect.se/sigval/](https://sandbox.swedenconnect.se/sigval/). This implementation validates elecronic signatures against the EU trusted list (TSL) as well as validatin based on SVT and provides the capability to extend XML and PDF docuemtns with SVT tokens.


Contributing
------------

This is the preliminary repository for developing drafts related to signature validation tokens intended for standardization and publication as an IETF standards track RFC.

This repository may be replaces at a later stage with a repository assigned by the IETF.

Contributions are wellcome either by

- submitting issues
- by providing pull requests
- by sending e-mail to the authors (see current draft for author contact info)

Building The Drafts
------------------

Each draft folder has a build script for building the txt drafts

This requires locally installed kramdown-rfc2629 (https://github.com/cabo/kramdown-rfc2629)
and xml2rfc (https://xml2rfc.tools.ietf.org/).

Submission procedure
------------------

1. Build the draft to be submitted
2. Rename draft to the appropriate version number and remove "-SNAPSHOT" from name.
3. Create a published/draft-nn folder inside the target draft folder and place relevant markdown and text document of the submited version.
4. Update the version number of the current working draft.
5. Create a new release of the Github repo.


Issue processing procedure
------------------

Create an issue in the repo

**If issue is a minor issue:** fix the issue in master and close the issue

**If the issue is a substantial issue:**
  1. Create a branch named after the issue
  2. Fix the issue
  3. Create a pull request and request review
  4. Iterate until issue is resolved
  5. Merge to master and close the issue


NOTE WELL
---------

Any submission to the [IETF](https://www.ietf.org/) intended by the Contributor
for publication as all or part of an IETF Internet-Draft or RFC and any
statement made within the context of an IETF activity is considered an "IETF
Contribution". Such statements include oral statements in IETF sessions, as
well as written and electronic communications made at any time or place, which
are addressed to:

 * The IETF plenary session
 * The IESG, or any member thereof on behalf of the IESG
 * Any IETF mailing list, including the IETF list itself, any working group
   or design team list, or any other list functioning under IETF auspices
 * Any IETF working group or portion thereof
 * Any Birds of a Feather (BOF) session
 * The IAB or any member thereof on behalf of the IAB
 * The RFC Editor or the Internet-Drafts function
 * All IETF Contributions are subject to the rules of
   [RFC 5378](https://tools.ietf.org/html/rfc5378) and
   [RFC 3979](https://tools.ietf.org/html/rfc3979)
   (updated by [RFC 4879](https://tools.ietf.org/html/rfc4879)).

Statements made outside of an IETF session, mailing list or other function,
that are clearly not intended to be input to an IETF activity, group or
function, are not IETF Contributions in the context of this notice.

Please consult [RFC 5378](https://tools.ietf.org/html/rfc5378) and [RFC
3979](https://tools.ietf.org/html/rfc3979) for details.

A participant in any IETF activity is deemed to accept all IETF rules of
process, as documented in Best Current Practices RFCs and IESG Statements.

A participant in any IETF activity acknowledges that written, audio and video
records of meetings may be made and may be available to the public.
