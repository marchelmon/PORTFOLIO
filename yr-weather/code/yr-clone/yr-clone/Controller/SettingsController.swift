//
//  SettingsController.swift
//  yr-clone
//
//  Created by marchelmon on 2021-06-16.
//

import UIKit


private let settingsCellIdentifier = "SettingsCell"

class SettingsController: UITableViewController {
    
    //MARK: - Properties
    
    private var currentTypeSelection: SettingType?
    private var lastSelectedCell: SettingsCell?
    
    private lazy var footerView: UIView = {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        let image = UIImageView(image: #imageLiteral(resourceName: "yr-logotext").withRenderingMode(.alwaysOriginal))
        image.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        image.contentMode = .scaleAspectFit
        footer.addSubview(image)
        image.centerY(inView: footer)
        return footer
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: settingsCellIdentifier)
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = footerView

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            tableView.tableFooterView = nil
        } else {
            tableView.tableFooterView = footerView
        }
    }
    
    //MARK: - Helpers
    
    func handleNewDataSelection(withIndex index: Int) {
        guard let currentType = currentTypeSelection else { return }
        let newData = Service.shared.getItemFromSettingData(withType: currentType, withIndex: index)
        
        guard let cell = lastSelectedCell else { return }
        
        cell.selectionText.text = newData
        
    }
    
}

//MARK: - UITableViewDelegate and UITableViewDataSource

extension SettingsController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? Dummy.shared.settingRows.count : 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellIdentifier, for: indexPath) as! SettingsCell
        cell.settingsRow = nil
        if indexPath.section == 0 {
            
            cell.settingsRow = Dummy.shared.settingRows[indexPath.row]
            if indexPath.row == 0 { cell.addOverline() }
            let underlinePadding = indexPath.row == Dummy.shared.settingRows.count - 1 ? 0 : 15
            cell.addUnderline(withLeftPadding: CGFloat(underlinePadding))
            
        } else {
            
            let text = indexPath.row == 0 ? "About" : "Data"
            cell.addTextLabel(withText: text)
            cell.addArrow()
            if indexPath.row == 0 {
                cell.addOverline()
                cell.addUnderline(withLeftPadding: 15)
            }
            if indexPath.row == 1 { cell.addUnderline() }
            
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            guard let cell = tableView.cellForRow(at: indexPath) as? SettingsCell else { return }
            lastSelectedCell = cell
            
            guard let selectedRowType = cell.settingsRow?.type else { return }
            
            currentTypeSelection = selectedRowType
            let tableData = Service.shared.getSettingData(fromType: selectedRowType)
            
            let controller = SetSettingController(withTableData: tableData, selectedIndex: 0, parentController: self)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}




