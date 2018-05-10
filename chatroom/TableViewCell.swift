//
//  TableViewCell.swift
//  chatroom
//
//  Created by 斧田洋人 on 2018/03/29.
//  Copyright © 2018年 斧田洋人. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    func enter(_ cell: TableViewCell)
    }

class TableViewCell: UITableViewCell {
    
    weak var delegate: CellDelegate?
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func enter(_ sender: Any) {
        delegate?.enter(self)
    }
    
}
