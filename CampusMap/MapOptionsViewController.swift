//
//  MapOptionsViewController.swift
//  CampusMap
//
//  Created by Chun on 2018/11/27.
//  Copyright © 2018 Nemoworks. All rights reserved.
//

import UIKit


enum MapOptionsType: Int {
    case mapBoundary = 0
    case mapPOIsSchoolBuilding
    case mapPOIsDormitory
    case mapPOIsFood
    case mapPOIsSport
    case mapPOIsGate
    case mapPOIsOtherBuilding
    
    func displayName() -> String {
        switch (self) {
        case .mapBoundary:
            return "校园边界"
        case .mapPOIsSchoolBuilding:
            return "教学楼与院系楼"
        case .mapPOIsDormitory:
            return "学生公寓"
        case .mapPOIsFood:
            return "食堂"
        case .mapPOIsSport:
            return "运动场所"
        case .mapPOIsGate:
            return "校门"
        case .mapPOIsOtherBuilding:
            return "其他建筑"
        
        }
    }
}

class MapOptionsViewController: UIViewController {

    var selectedOptions = [MapOptionsType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - UITableViewDataSource
extension MapOptionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell")!
        
        if let mapOptionsType = MapOptionsType(rawValue: indexPath.row) {
            cell.textLabel!.text = mapOptionsType.displayName()
            cell.accessoryType = selectedOptions.contains(mapOptionsType) ? .checkmark : .none
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MapOptionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard let mapOptionsType = MapOptionsType(rawValue: indexPath.row) else { return }
        
        if (cell.accessoryType == .checkmark) {
            // Remove option
            selectedOptions = selectedOptions.filter { $0 != mapOptionsType}
            cell.accessoryType = .none
        } else {
            // Add option
            selectedOptions += [mapOptionsType]
            cell.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
