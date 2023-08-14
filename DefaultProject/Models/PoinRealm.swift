//
//  PoinRealm.swift
//  DefaultProject
//
//  Created by daktech on 14/08/2023.
//

import Foundation
import RealmSwift

class Point: Object, ObjectKeyIdentifiable {
    convenience init(pointMath: Int? = 0, pointListen: Int? = 0, pointHistory: Int? = 0, pointSurrounding: Int? = 0, pointColor: Int? = 0) {
        self.init()
        self.pointMath = pointMath ?? 0
        self.pointListen = pointListen ?? 0
        self.pointHistory = pointHistory ?? 0
        self.pointSurrounding = pointSurrounding ?? 0
        self.pointColor = pointColor ?? 0
    }
    
    @Persisted(primaryKey: true) var id: String = "Point"
    @Persisted var pointMath: Int = 0
    @Persisted var pointListen: Int = 0
    @Persisted var pointHistory: Int = 0
    @Persisted var pointSurrounding: Int = 0
    @Persisted var pointColor: Int = 0
    
    static func savePoint(pointMath: Int? = nil, pointListen: Int? = nil, pointHistory: Int? = nil, pointSurrounding: Int? = nil, pointColor: Int? = nil) {
        let realm = try! Realm()
        
        do{
            try realm.write{
                if let obj = realm.object(ofType: Point.self, forPrimaryKey: "Point") {
                    if let pointHistory = pointHistory{
                        obj.pointHistory = pointHistory
                    }
                    
                    if let pointMath = pointMath{
                        obj.pointMath = pointMath
                    }
                    
                    if let pointListen = pointListen{
                        obj.pointListen = pointListen
                    }
                    
                    if let pointSurrounding = pointSurrounding{
                        obj.pointSurrounding = pointSurrounding
                    }
                    
                    if let pointColor = pointColor{
                        obj.pointColor = pointColor
                    }
                }
            }
        }catch let error{
            print(error.localizedDescription)
        }
    }
}
