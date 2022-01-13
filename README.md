# TTSLanguage

Text To Speech commandline executable for macOS.
It can detect sentence language and read it using proper voice.

example: 

`$ TTSLanguage "Hello my Friend! Bonjour camarade! Cześć kolego."`

It can also read `lang` attributes from html. example:

`$ TTSLanguage "<span lang=\"en-US\">In Paris the name of the city is pronounced</span><span lang=\"fr-FR\">Paris</span>"`

It's created for an answer to AskDifferent question: https://apple.stackexchange.com/q/434992/74657

## Installation

### Compiled
Compiled sources can be found in `Playground/Testing.playground/Resources/TTSLanguage.zip`

In order to use it in different places remember to store `TTSLanguageLib.framework` in the same dir as `TTSLanguage` executable.

### Building

Everything could be build using Xcode

## macOS Service

It can be run as a macOS service. 
- In Automator.app create Service with text input.
- Add "Run shell Sscript" block
- Change input type to stdin
- Place this script inside: 
``` 
myVar=$(</dev/stdin)
$PATH_TO_TTSLanguage_EXECUTABLE "$myVar"
```
NOTE: `$PATH_TO_TTSLanguage_EXECUTABLE` is the place on disk where you stored `TTSLanguage` executable.

## Dependencies

- HTML parsing with `SwiftSoup` (https://github.com/scinfu/SwiftSoup.git)
- Using `NaturalLanguage` framework available in macOS 10.14 (https://developer.apple.com/documentation/naturallanguage)
