//
//  TrainInfoCell.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

protocol CellDelegate: AnyObject {
    func makeFavourite(_ train: StationTrain?)
}
class TrainInfoCell: UITableViewCell {
    @IBOutlet weak var destinationTimeLabel: UILabel!
    @IBOutlet weak var sourceTimeLabel: UILabel!
    @IBOutlet weak var destinationInfoLabel: UILabel!
    @IBOutlet weak var souceInfoLabel: UILabel!
    @IBOutlet weak var trainCode: UILabel!
    @IBOutlet weak var heartButton: UIButton!

    weak var delegate: CellDelegate!
    
    var train : StationTrain? {
        didSet {
            guard let train = train else { return }
            
            let heartImage = UIImage(systemName: "heart.fill")
            let image = (train.favorite ?? false) ? heartImage : UIImage(systemName: "heart")
            heartButton.setImage(image, for: .normal)
            trainCode.text = train.trainCode
            souceInfoLabel.text = train.stationFullName
            sourceTimeLabel.text = train.expDeparture
            if let _destinationDetails = train.destinationDetails {
                destinationInfoLabel.text = _destinationDetails.locationFullName
                destinationTimeLabel.text = _destinationDetails.expDeparture
            }
        }
    }
    
    @IBAction func makefavourite(_ sender: Any) {
        delegate.makeFavourite(train)
    }
}
