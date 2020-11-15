//
//  TableViewConfig.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import UIKit
import SwiftUI

class TableViewConfig {
    
    static let shared = TableViewConfig()
    
    let background: UIColor = UIColor.background!
    let backgroundDialog: UIColor = UIColor.backgroundDialog!
    
    func themeMenu() {
        let colorView = UIView()
        colorView.backgroundColor = UIColor.primaryLight
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().isScrollEnabled = false
        UITableView.appearance().backgroundColor = backgroundDialog
        UITableViewCell.appearance().selectedBackgroundView = colorView
        UITableViewCell.appearance().backgroundColor = backgroundDialog
    }
    
    func themeBackground() {
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().isScrollEnabled = true
        UITableView.appearance().backgroundColor = background
        UITableViewCell.appearance().selectionStyle = .gray
        UITableViewCell.appearance().backgroundColor = background
    }
    
    func themeDialog(scroll: Bool = false,
                     selectionStyle: UITableViewCell.SelectionStyle = .gray) {
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().isScrollEnabled = scroll
        UITableView.appearance().backgroundColor = backgroundDialog
        UITableViewCell.appearance().selectionStyle = selectionStyle
        UITableViewCell.appearance().backgroundColor = backgroundDialog
    }
    
    func themeContacts() {
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().isScrollEnabled = true
        UITableView.appearance().backgroundColor = background
        UITableViewCell.appearance().selectionStyle = .none
        UITableViewCell.appearance().backgroundColor = background
    }
}
