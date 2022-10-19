//
//  Router.swift
//  ProjectNew
//
//  Created by Vinoth on 09/10/22.
//

import Foundation

public protocol BaseRouter: Router { }

extension BaseRouter {
    
    public var method: HTTPMethod { .get }
    
    public var path: String { "" }
    
    public var params: [String: Any] {  [:] }
    
    public var baseUrl: URL {
        URL(string: "http://api.irishrail.ie/realtime/realtime.asmx/")!
    }
        
    public var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
    
    public var keypathToMap: String? {  nil }
}

enum StationRouter: BaseRouter {
    case getAllStations(_ type: String)
    case getStationByCode(_ code: String)
    case getTrainMovements(_ trainId: String, trainDate: String)
    
    var path: String {
        switch self {
        case .getAllStations:
            return "getAllStationsXML"
        case .getStationByCode(let code):
            return "getStationDataByCodeXML?StationCode=" + code
        case .getTrainMovements(let trainId, let trainDate):
            return "getTrainMovementsXML?TrainId=\(trainId)&TrainDate=\(trainDate)"
        }
    }
}
