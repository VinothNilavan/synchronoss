//
//  NetworkManager.swift
//  ProjectNew
//  Created by Vinoth on 04/10/22.
//

import Foundation

public typealias APICompletion<T> = (APIResult<T>) -> Void

class NetworkManager {
    static func getAllStations(type: String? = "" , completion: @escaping APICompletion<Stations>) {
        ApiClient.shared.request(StationRouter.getAllStations(type ?? ""), completion: completion)
    }
    static func getStationByCode(code: String, completion: @escaping APICompletion<StationData>) {
        ApiClient.shared.request(StationRouter.getStationByCode(code), completion: completion)
    }
    static func getMovementTrain(trainId: String, date: String, completion: @escaping APICompletion<TrainMovementsData>) {
        let router = StationRouter.getTrainMovements(trainId, trainDate: date)
        ApiClient.shared.request(router, completion: completion)
    }
}
