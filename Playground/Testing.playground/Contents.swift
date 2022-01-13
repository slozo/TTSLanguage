import Cocoa
import TTSLanguageLib

let filePath = Bundle.main.path(forResource:"index", ofType: "html")
// get the contentData
let contentData = FileManager.default.contents(atPath: filePath!)
// get the html string
let content = String(data:contentData!, encoding:String.Encoding.utf8)!

let s = Synth(text: content)
