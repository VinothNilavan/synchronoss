//
//  DataModel.swift
//  MyTravelHelper
//
//  Created by Vinoth on 19/10/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation
struct DataModelKey {
    static let db = "kTrains"
}

class DB {
    static let shared = DB()
    private init() { }
    
    func saveObject(_ key: String = DataModelKey.db, _ objects: [StationTrain]) {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // if any object stored add it again.
            var oldData = getObject(key )
            for object in objects {
                if let index = oldData.firstIndex(where: {$0.stationCode == object.stationCode}) {
                    oldData.remove(at: index)
                } else {
                    oldData.append(object)
                }
            }
            
            // Encode Note
            let data = try encoder.encode(oldData)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
        } catch {
            print("Unable to Encode Array of (\(error))")
        }
    }
    
    func getObject(_ key: String = DataModelKey.db ) -> [StationTrain] {
        // Read/Get Data
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Chars
                return try decoder.decode([StationTrain].self, from: data)
            } catch {
                print("Unable to Decode  (\(error))")
            }
        }
        return []
    }
    
    func updateObject(_ train: StationTrain) -> [StationTrain] {
        var trains = getObject()
        if !(train.favorite ?? true) {
            guard let index = trains.firstIndex(where: {$0.stationCode == train.stationCode}) else { return  [] }
            trains.remove(at: index)
        } else {
            trains = [train]
        }
        do {
            let data = try JSONEncoder().encode(trains)
            // Write/Set Data
            UserDefaults.standard.set(data, forKey: DataModelKey.db)
            UserDefaults.standard.synchronize()
        }
        catch {
            print(error)
        }
        return trains
    }
}
