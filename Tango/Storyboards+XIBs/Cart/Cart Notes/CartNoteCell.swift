//
//  CartNoteCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 14/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol CustomNotesAdd {
    func customNotesAdd()
}

class CartNoteCell: UITableViewCell {
    
    var noteDelegate : CustomNotesAdd?
    @IBOutlet weak var lblNote: UILabel!
    static let identifier = "CartNoteCell"
    static func nib() -> UINib{
        return UINib(nibName: "CartNoteCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnCustomNotesAction(_ sender: Any) {
        noteDelegate?.customNotesAdd()
    }
}
