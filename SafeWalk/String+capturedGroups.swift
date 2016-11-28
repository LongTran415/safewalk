/*
 See: http://samwize.com/2016/07/21/how-to-capture-multiple-groups-in-a-regex-with-swift/
 
*/

import Foundation

extension String {
  
  func capturedGroups(withRegex pattern: String) -> [String] {
    var results = [String]()
    
    var regex: NSRegularExpression
    do {
      regex = try NSRegularExpression(pattern: pattern, options: [])
    } catch {
      return results
    }
    
    let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.characters.count))
    
    guard let match = matches.first else { return results }
    
    let lastRangeIndex = match.numberOfRanges - 1
    guard lastRangeIndex >= 1 else { return results }
    
    for i in 1...lastRangeIndex {
      let capturedGroupIndex = match.rangeAt(i)
      let matchedString = (self as NSString).substring(with: capturedGroupIndex)
      results.append(matchedString)
    }
    
    return results
  }
}
