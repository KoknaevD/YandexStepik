//
//  NoteExtension.swift
//  Notebook
//
//  Created by Admin on 30.06.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit


extension Note{
    static func parse(json: [String:Any]) -> Note? {
        
        //Проверяем 3 обязательных свойства, если нет - хотя бы 1 - возвращаем nil
        guard let title = json["title"] as? String,
            let uid = json["uid"] as? String,
            let content = json["content"] as? String
            else {return nil}
        
        
        var color = UIColor.white //По-умолчанию ставим белый
        if let tempColor = json["color"] as? [String : Any] {
            guard let iRed = tempColor["red"] as? Int,
                let iGreen = tempColor["green"] as? Int,
                let iBlue = tempColor["blue"] as? Int,
                let iAlpha = tempColor["alpha"] as? Int
                else {return nil}       //Если прилетает кривой запрос - возвращаем nil
            
            color = UIColor(red: CGFloat(Double(iRed) / 255.0),
                            green : CGFloat(Double(iGreen) / 255.0),
                            blue : CGFloat(Double(iBlue) / 255.0),
                            alpha: CGFloat(Double(iAlpha) / 255.0))
            
        }
        
        let importance = Importance(rawValue: json["importance"] as? String ?? "") ?? Importance.regular
        
        var date: Date?
        if let tempDate = json["selfDestructionDate"] as? Double {
            date = Date(timeIntervalSince1970: tempDate)
        }
        
        
        let newNote = Note(uid: uid, title: title, content: content, color: color, importance: importance, selfDestructionDate: date)
        return newNote
    }
    
    var json: [String: Any] {
        var dict = [String:Any]()
        dict["uid"] = self.uid
        dict["title"] = self.title
        dict["content"] = self.content
        if self.color != UIColor.white {
            var fRed : CGFloat   = 0
            var fGreen : CGFloat = 0
            var fBlue : CGFloat  = 0
            var fAlpha : CGFloat = 0
            if self.color.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
                var colorDict = [String : Int]()
                colorDict["red"] = Int(fRed * 255.0)
                colorDict["green"] = Int(fGreen * 255.0)
                colorDict["blue"] = Int(fBlue * 255.0)
                colorDict["alpha"] = Int(fAlpha * 255.0)
                dict["color"] = colorDict
            }
        }
        
        if self.importance != .regular {
            dict["importance"] = self.importance.rawValue
        }
        
        if let d = self.selfDestructionDate {
            dict["selfDestructionDate"] = d.timeIntervalSince1970
        }
        
        
        return dict
    }
}
