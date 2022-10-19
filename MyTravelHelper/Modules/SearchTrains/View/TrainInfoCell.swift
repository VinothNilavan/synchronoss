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
    weak var delegate: CellDelegate!
    var train : StationTrain?
    
    @IBAction func makefavourite(_ sender: Any) {
        delegate.makeFavourite(train)
    }
}
