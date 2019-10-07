import UIKit


enum Importance : String{
    case unimportant = "unimportant"
    case regular = "regular"
    case important = "important"
}

struct Note {
    let uid : String
    let title : String
    let content : String
    let color : UIColor
    let importance : Importance
    let selfDestructionDate : Date?
    
    init(uid : String = UUID().uuidString, title : String, content: String, color : UIColor = UIColor.white, importance: Importance, selfDestructionDate : Date? = nil)
    {
        self.uid = uid
        self.color = color
        self.title = title
        self.content = content
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
    }
}

