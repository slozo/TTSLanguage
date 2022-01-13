//
//  Synth.swift
//  TTSLanguageLib
//
//  Created by Mateusz Szlosek on 13/01/2022.
//

import Foundation
import SwiftSoup
import NaturalLanguage
import AVFoundation

open class Synth: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private var lastUtterance: AVSpeechUtterance?

    public init(text: String) {
        super.init()

        synthesizer.delegate = self

        let utterances: [AVSpeechUtterance] = {
            if let doc: Document = try? SwiftSoup.parse(text),
               let elements = try? doc.getAllElements() {
                return parseHTML(elements: elements)
            } else {
                return parse(text: text)
            }
        }()

        lastUtterance = utterances.last

        for utterance in utterances {
            synthesizer.speak(utterance)
        }
    }

    private func parseHTML(elements: Elements) -> [AVSpeechUtterance] {
        return elements
            .flatMap { $0.textNodes() }
            .flatMap { node -> [AVSpeechUtterance] in
                if let lang = try? node.parent()?.attr("lang"), !lang.isEmpty {
                    let u = AVSpeechUtterance(string: node.text())
                    u.voice = AVSpeechSynthesisVoice(language: lang)
                    return [u]
                } else {
                    return parse(text: node.text())
                }
            }
    }

    private func parse(text: String) -> [AVSpeechUtterance] {
        var u = [AVSpeechUtterance]()
        let tagger = NLTagger(tagSchemes: [.language])
        tagger.string = text
        tagger.enumerateTags(in: text.startIndex..<text.endIndex,
                             unit: .sentence,
                             scheme: .language,
                             options: []) { tag, tokenRange in
            let txt = String(text[tokenRange])
            let languageCode = NSLinguisticTagger.dominantLanguage(for: txt) ?? AVSpeechSynthesisVoiceIdentifierAlex

            let utterance = AVSpeechUtterance(string: txt)
            utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
            u.append(utterance)
            return true
        }
        return u
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard let lastUtterance = lastUtterance else {
            exit(-1)
        }
        if lastUtterance == utterance {
            exit(0)
        }
    }
}
