//
//  SetSettingController.swift
//  yr-clone
//
//  Created by marchelmon on 2021-06-17.
//

import UIKit

private let reuseIdentifier = "SetSettingCell"

class SetSettingController: UITableViewController {
    
    //MARK: - Properties
    
    private let tableData: [String]
    private let parentController: SettingsController
    private var selectedIndex: Int

    
    //MARK: - Lifecycle
    
    init(withTableData data: [String], selectedIndex: Int, parentController: SettingsController) {
        self.tableData = data
        self.selectedIndex = selectedIndex
        self.parentController = parentController
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
}

//MARK: - UITableViewDelegate and UITableViewDataSource

extension SetSettingController {
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tableData.count }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 50 }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        cell.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        for row in 0...tableData.count {
            let rowIndexPath = IndexPath(item: row, section: 0)
            guard let cell = tableView.cellForRow(at: rowIndexPath) else { return }
            if row == indexPath.row {
                cell.accessoryType = .checkmark
                selectedIndex = indexPath.row
                parentController.handleNewDataSelection(withIndex: selectedIndex)
            } else {
                cell.accessoryType = .none
            }
        }
        
    }
    
    
}
