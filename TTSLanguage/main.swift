//
//  main.swift
//  TTSLanguage
//
//  Created by Mateusz Szlosek on 12/01/2022.
//

import Foundation
import TTSLanguageLib

var text = CommandLine.arguments.dropFirst().reduce("", +)
text = text.isEmpty ? "No text" : text
let s = Synth(text: text)

RunLoop.main.run()
