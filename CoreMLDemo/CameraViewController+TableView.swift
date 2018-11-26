//
//  CameraViewController+TableView.swift
//  CoreMLDemo
//
//  Created by Xu, Zhaocheng on 11/26/18.
//  Copyright © 2018 Xu, Zhaocheng. All rights reserved.
//

import Foundation
import UIKit

extension CameraViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelName = self.models[indexPath.row]
        let updateRows = [indexPath, IndexPath(row: self.selectedIndex, section: 0)]
        self.selectedIndex = indexPath.row
        self.setupModel(modelName)

        self.settingTableView.reloadRows(at: updateRows, with: .none)
        self.showSettingView(false)
        self.showBlurView(false)
    }
}

extension CameraViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Model Cell", for: indexPath) as! ModelCell

        cell.nameLabel.text = self.models[indexPath.row]
        cell.tickLabel.isHidden = indexPath.row == self.selectedIndex ? false : true
        return cell
    }


}
