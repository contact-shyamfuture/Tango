//
//  WalletsHistoryCell.swift
//  Tango
//
//  Created by Samir Samanta on 31/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class WalletsHistoryCell: UITableViewCell {
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAmountType: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeCellDetails(cell : WalletsModel){
        lblAmount.text = cell.amount
        lblAmountType.text = cell.status
        let date = formatDate(date: cell.created_at!)
        lbldate.text = date //cell.created_at
    }
    
    func formatDate(date: String) -> String {
       let dateFormatterGet = DateFormatter()
       dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "EEE , MMM dd, HH : mm a"

       let date: Date? = dateFormatterGet.date(from: "2017-02-14 17:24:26")
       print(dateFormatter.string(from: date!))
        
       return dateFormatter.string(from: date!)
    }
}
