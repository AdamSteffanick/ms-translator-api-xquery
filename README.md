# Microsoft Cognitive Services Translator API XQuery [![version](https://img.shields.io/badge/ms--translator--api--xquery-v0.1.0-0038e2.svg?style=flat-square)][CHANGELOG]
Make requests to [Microsoft Translator APIs] with XQuery.

## Download
* [**Latest release**](https://github.com/AdamSteffanick/ms-translator-api-xquery/releases/latest)

## Documentation
For BaseX and [Microsoft Translator APIs], import the function library [ms-translator-api-basex.xquery] v0.1.0:

`import module namespace ms-translator-api="ms-translator-api-basex" at "https://raw.githubusercontent.com/AdamSteffanick/ms-translator-api-xquery/v0.1.0/ms-translator-api-basex.xquery";`

* Fork or download this repository if you prefer to use your own copy of the function library (*i.e.*, [ms-translator-api-basex.xquery])
* Tutorials
  * [Retrieve Microsoft Translator API Access Tokens with XQuery and BaseX](https://www.steffanick.com/adam/blog/retrieve-microsoft-translator-api-access-tokens-with-xquery/)

## Features
* [Authentication Token API] v1.0.0 compatible

[CHANGELOG]: ./CHANGELOG.md
[ms-translator-api-basex.xquery]: ./ms-translator-api-basex.xquery

[Authentication Token API]: http://docs.microsofttranslator.com/oauth-token.html
[Microsoft Translator APIs]: https://docs.microsofttranslator.com/
[Microsoft Translator Text API]: https://docs.microsofttranslator.com/text-translate.html