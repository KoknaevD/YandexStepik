//
//  NoteBook.swift
//  Notebook
//
//  Created by Admin on 30.06.2019.
//  Copyright © 2019 Admin. All rights reserved.
//
import Foundation

class NoteBook {
    private let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    
    private var _NoteDict = [String : Note]() //доступа на запись нет
    public var NoteDict : [String: Note] {return _NoteDict}  //реализуем доступ на чтение, так можно!
    
    //Заметки хранятся в словаре, если найдет заметку с повторным айди - ничего не делает
    public func add(_ note: Note) {
        if let _ = _NoteDict[note.uid] {
        } else {
            self._NoteDict[note.uid] = note
        }
    }
    
    //Т.к. повторов нет - просто затераем
    public func remove(with uid: String) {
        _NoteDict[uid] = nil
    }
    
    public func saveToFile() {
        var isDir: ObjCBool = false
        let dirurl = path.appendingPathComponent("MyNoteBookFolder")
        print(dirurl)
        if FileManager.default.fileExists(atPath: dirurl.path, isDirectory: &isDir), isDir.boolValue {
        } else {
            try? FileManager.default.createDirectory(at: dirurl, withIntermediateDirectories: true, attributes: nil)
        }
        
        
        //еще раз проверим, а создалась ли папка
        if FileManager.default.fileExists(atPath: dirurl.path, isDirectory: &isDir), isDir.boolValue {
            let filename = dirurl.appendingPathComponent("MyNotebook.ntb")
            var jsxArray = [Any]()
            for el in _NoteDict {
                jsxArray.append(el.value.json)
            }
            
            do {
                let jsdata = try JSONSerialization.data(withJSONObject: jsxArray, options: [])
                try? FileManager.default.createFile(atPath: filename.path, contents: jsdata, attributes: nil)
            } catch {
            }
        }
    }
    
    public func loadFromFile(){
        self._NoteDict = [String : Note]() //очистим текущую книжку, что б не задублировать чего
        let filename = path.appendingPathComponent("MyNoteBookFolder/MyNotebook.ntb")
        if FileManager.default.fileExists(atPath: filename.path){
            do {
                let data = try NSData.init(contentsOfFile: filename.path) as Data
                if let jsxArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]{
                    for element in jsxArray {
                        let json = element as! [String:Any]
                        if let newNote2 = Note.parse(json: json) {
                            self.add(newNote2)
                        }
                    }
                    
                }
            } catch
            {}
        }
    }
}
