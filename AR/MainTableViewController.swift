//
//  MainTableViewController.swift
//  AR
//
//  Created by Krishna Venkatramani on 06/04/2023.
//

import Foundation
import UIKit


enum Pages: String, CaseIterable {
    case simpleAR = "Simple AR"
    case tableAR = "Table AR"
    case ARPositioning = "AR Positioning"
    case videoPlayer = "Video Player"
    case drawer = "Drawing in AR"
}

extension Pages {
    var destination: UIViewController {
        switch self {
        case .simpleAR:
            return ViewController()
        case .tableAR:
            return TableARController()
        case .ARPositioning:
            return ARPositioningViewController()
        case .videoPlayer:
            return VideoPlayer()
        case .drawer:
            return DrawingARApp()
        }
    }
}

class MainViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table: UITableView = .init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.setFittingConstraints(childView: tableView, insets: .zero)
        tableView.reloadData()
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { Pages.allCases.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Pages.allCases[indexPath.row].rawValue
        cell.textLabel?.font = .preferredFont(forTextStyle: .title3)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPage = Pages.allCases[indexPath.row]
        navigationController?.pushViewController(selectedPage.destination, animated: true)
    }
}
