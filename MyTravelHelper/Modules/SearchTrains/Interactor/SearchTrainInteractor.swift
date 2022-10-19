//
//  SearchTrainInteractor.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation
import XMLParsing

class SearchTrainInteractor: PresenterToInteractorProtocol {
    var _sourceStationCode = String()
    var _destinationStationCode = String()
    var presenter: InteractorToPresenterProtocol?

    func fetchallStations() {
        if Reach().isNetworkReachable() == true {
            NetworkManager.getAllStations { stationsResult in
                switch stationsResult {
                case .success(let stations):
                    self.presenter!.stationListFetched(list: stations.stationsList)
                case .failure(let err):
                    self.presenter!.showMessage(err.localizedDescription)
                }
            }
        } else {
            self.presenter!.showNoInterNetAvailabilityMessage()
        }
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        _sourceStationCode = sourceCode
        _destinationStationCode = destinationCode
        NetworkManager.getStationByCode(code: sourceCode) { result in
            switch result {
            case .success(let st):
                if let trains =  st.trainsList {
                    self.proceesTrainListforDestinationCheck(trainsList: trains)
                } else {
                    self.presenter!.showNoTrainAvailbilityFromSource()
                }
            case .failure(let err):
                self.presenter!.showMessage(err.localizedDescription)
            }
        }
        
//        let urlString = "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML?StationCode=\(sourceCode)"
//        if Reach().isNetworkReachable() {
//            Alamofire.request(urlString).response { (response) in
//                let stationData = try? XMLDecoder().decode(StationData.self, from: response.data!)
//                if let _trainsList = stationData?.trainsList {
//                    self.proceesTrainListforDestinationCheck(trainsList: _trainsList)
//                } else {
//                    self.presenter!.showNoTrainAvailbilityFromSource()
//                }
//            }
//        } else {
//            self.presenter!.showNoInterNetAvailabilityMessage()
//        }
    }
    
    private func proceesTrainListforDestinationCheck(trainsList: [StationTrain]) {
        guard Reach().isNetworkReachable() else  {
            self.presenter!.showNoInterNetAvailabilityMessage()
            return
        }
        
        var _trainsList = trainsList
        let today = CurrentDate
        let group = DispatchGroup()
        for (index, value) in trainsList.enumerated() {
            group.enter()
            NetworkManager.getMovementTrain(trainId: value.trainCode, date: today) { result in
                group.leave()
                switch result {
                case .success(let trainMovements):
                     let _movements = trainMovements.trainMovements

                    if !_movements.isEmpty {
                        let sourceIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._sourceStationCode) == .orderedSame})
                        let destinationIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame})
                        let desiredStationMoment = _movements.filter{$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame}
                        let isDestinationAvailable = desiredStationMoment.count == 1
                        
                        if isDestinationAvailable  && sourceIndex! < destinationIndex! {
                            _trainsList[index].destinationDetails = desiredStationMoment.first
                        }
                    }
                case .failure(let er):
                    self.presenter!.showMessage(er.localizedDescription)
                }
            }
        }
        /*
        for index  in 0...trainsList.count-1 {
            group.enter()
            let _urlString = "http://api.irishrail.ie/realtime/realtime.asmx/getTrainMovementsXML?TrainId=\(trainsList[index].trainCode)&TrainDate=\(today)"
            if Reach().isNetworkReachable() {
                Alamofire.request(_urlString).response { (movementsData) in
                        let trainMovements = try? XMLDecoder().decode(TrainMovementsData.self, from: movementsData.data!)
                        
                        if let _movements = trainMovements?.trainMovements {
                            let sourceIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._sourceStationCode) == .orderedSame})
                            let destinationIndex = _movements.firstIndex(where: {$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame})
                            let desiredStationMoment = _movements.filter{$0.locationCode.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame}
                            let isDestinationAvailable = desiredStationMoment.count == 1
                            
                            if isDestinationAvailable  && sourceIndex! < destinationIndex! {
                                _trainsList[index].destinationDetails = desiredStationMoment.first
                            }
                        }
                    group.leave()
                }
            } else {
                self.presenter!.showNoInterNetAvailabilityMessage()
            }
        }
         */

        group.notify(queue: DispatchQueue.main) {
            let sourceToDestinationTrains = _trainsList.filter{$0.destinationDetails != nil}
            self.presenter!.fetchedTrainsList(trainsList: sourceToDestinationTrains)
        }
    }
}
