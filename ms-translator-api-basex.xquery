xquery version "3.1" encoding "UTF-8";

module namespace ms-translator-api = "ms-translator-api-basex";

(:~
 : A library module for Microsoft Cognitive Services Translator API.
 :
 : @author Adam Steffanick
 : https://www.steffanick.com/adam/
 : @version v0.1.0
 : https://github.com/AdamSteffanick/ms-translator-api-xquery
 :)

(:
MIT License

Copyright (c) 2017 Adam Steffanick

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
:)

(: # Microsoft Cognitive Services Translator API functions :)
(: ## Authentication Token API v1.0.0 :)
(:~
 : Retrieve an Azure authentication token from the Authentication Token API
 : for Microsoft Cognitive Services Translator API and prefix "Bearer ".
 :)
declare function ms-translator-api:retrieveAccessToken(
  $azureKey as xs:string
) as xs:string {
  let $authenticationRequest := (
    <http:request method="post">
      <http:header name="Content-Type" value="application/json" />
      <http:header name="Accept" value="application/jwt" />
      <http:header name="Ocp-Apim-Subscription-Key" value="{$azureKey}" />
      <http:body media-type="application/json">
        <!-- a blank body returns HTTP Error 411 -->
      </http:body>
    </http:request>
  )
  let $authenticationResponse := http:send-request(
    $authenticationRequest,
    "https://api.cognitive.microsoft.com/sts/v1.0/issueToken"
  )   
  let $accessToken := fn:concat(
    "Bearer ",
    $authenticationResponse[2]
    => xs:base64Binary()
    => convert:binary-to-string()
  )
  return $accessToken
};
(: ## Microsoft Translator Text API v2.0.0 :)
(:~
 : Retrieve a base64Binary audio data stream in a desired language from text
 : passed to the Microsoft Cognitive Services Translator Text API.
 :)
declare function ms-translator-api:textToSpeech(
  $accessToken as xs:string,
  $text as xs:string,
  $language as xs:string,
  $format as xs:string?,
  $options as xs:string?
) as xs:base64Binary {
  let $mimeType := (
    if (
      $format = "audio/mp3"
    )
    then (
      "audio/mpeg"
    )
    else (
      "audio/x-wav"
    )
  )
  let $requiredParameters := map {
    "text=": $text,
    "language=": $language
  }
  let $optionalParameters := (
    if (
      fn:empty($format)
      or ($format = "")
    )
    then ()
    else (
      map {
        "format=": $format
      }
    ),
    if (
      fn:empty($options)
      or ($options = "")
    )
    then ()
    else (
      map {
        "options=": $options
      }
    )
  )
  let $buildQueryString := (
    function(
      $key,
      $value
    ) {
      fn:concat(
        $key,
        $value
        => fn:encode-for-uri()
        => fn:normalize-unicode()
      )
    }
  )
  let $queryString := (
    map:merge((
      $requiredParameters,
      $optionalParameters
    ))
    => map:for-each($buildQueryString)
    => fn:string-join("&amp;")
  )
  let $speakRequest := (
    <http:request method="get">
      <http:header name="Accept" value="{$mimeType}" />
      <http:header name="Authorization" value="{$accessToken}" />
    </http:request>
  )
  let $speakResponse := http:send-request(
    $speakRequest,
    fn:concat(
      "https://api.microsofttranslator.com/v2/http.svc/Speak?",
      $queryString
    )
  )
  let $audioData := $speakResponse[2]
  return $audioData
};