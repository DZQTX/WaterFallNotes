//
//  NotesModel.swift
//  AppDemo1
//
//  Created by 夜凛(丁志强) on 2024/7/3.
//

import Foundation
import YYModel

@objcMembers
public class NotesModel: NSObject, Codable,Identifiable{
    
    public var id: UUID = UUID()
    public var imageUrl: String?
    public var tittle: String?
    public var userMessage: String?
    public var likes: Int = 0
    
    func modelCustomPropertyMapper() -> [String: Any]{
        return ["tittle" : "tittle",
            "imageUrl" : "imageUrl",
            "userMessage" : "userMessage",
            "likes" : "likes"]
    }
}


