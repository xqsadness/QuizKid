//
//  PoinRealm.swift
//  DefaultProject
//
//  Created by daktech on 14/08/2023.
//

import Foundation
import RealmSwift

class Point: Object, ObjectKeyIdentifiable {
    convenience init(pointMath: Int? = 0, pointListen: Int? = 0, pointHistory: Int? = 0, pointSurrounding: Int? = 0, pointColor: Int? = 0, pointListenAndRepeat: Int? = 0) {
        self.init()
        self.pointMath = pointMath ?? 0
        self.pointListen = pointListen ?? 0
        self.pointHistory = pointHistory ?? 0
        self.pointSurrounding = pointSurrounding ?? 0
        self.pointColor = pointColor ?? 0
        self.pointListenAndRepeat = pointListenAndRepeat ?? 0
    }
    
    @Persisted(primaryKey: true) var id: String = "Point"
    @Persisted var pointMath: Int = 0
    @Persisted var pointListen: Int = 0
    @Persisted var pointHistory: Int = 0
    @Persisted var pointSurrounding: Int = 0
    @Persisted var pointColor: Int = 0
    @Persisted var pointListenAndRepeat: Int = 0
    
    static func savePoint(point: Point) {
        let realm = try! Realm()
        
        do {
            try realm.write {
                if let existingPoint = realm.object(ofType: Point.self, forPrimaryKey: "Point") {
                    existingPoint.pointMath = point.pointMath
                    existingPoint.pointListen = point.pointListen
                    existingPoint.pointHistory = point.pointHistory
                    existingPoint.pointSurrounding = point.pointSurrounding
                    existingPoint.pointColor = point.pointColor
                } else {
                    realm.add(point)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func updatePointHistory(newPointHistory: Int) {
        let realm = try! Realm()

        do {
            if let existingPoint = realm.object(ofType: Point.self, forPrimaryKey: "Point") {
                try realm.write {
                    existingPoint.pointHistory = newPointHistory
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func updatePointListen(point: Int) {
        let realm = try! Realm()

        do {
            if let existingPoint = realm.object(ofType: Point.self, forPrimaryKey: "Point") {
                try realm.write {
                    existingPoint.pointListen = point
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func updatePointMath(point: Int) {
        let realm = try! Realm()

        do {
            if let existingPoint = realm.object(ofType: Point.self, forPrimaryKey: "Point") {
                try realm.write {
                    existingPoint.pointMath = point
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func updatePointColor(point: Int) {
        let realm = try! Realm()

        do {
            if let existingPoint = realm.object(ofType: Point.self, forPrimaryKey: "Point") {
                try realm.write {
                    existingPoint.pointColor = point
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func updatePointSurrounding(point: Int) {
        let realm = try! Realm()

        do {
            if let existingPoint = realm.object(ofType: Point.self, forPrimaryKey: "Point") {
                try realm.write {
                    existingPoint.pointSurrounding = point
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func updatepointListenAndRepeat(point: Int) {
        let realm = try! Realm()

        do {
            if let existingPoint = realm.object(ofType: Point.self, forPrimaryKey: "Point") {
                try realm.write {
                    existingPoint.pointListenAndRepeat = point
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
