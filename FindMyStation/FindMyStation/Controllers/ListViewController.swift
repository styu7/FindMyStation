//
//  ListViewController.swift
//  FindMyStation
//
//  Created by YU on 01.12.23.
//

import UIKit
import CoreLocation
import Combine

class ListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var lastUpdateLabel: UILabel!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    private var cancellables = Set<AnyCancellable>()
    let viewModel: StationsViewModelProtocol
    
    // MARK: - Initialization
    
    init?(coder: NSCoder, viewModel: StationsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a viewModel.")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - ViewModel binding
    
    func bindViewModel() {
        
        viewModel.stationsDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.tableView.reloadData()
                self?.updateLastUpdateLabel()
            }
            .store(in: &cancellables)
        
        viewModel.isLoadingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.spinner.startAnimating()
                } else {
                    self?.spinner.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Last update label
    
    func updateLastUpdateLabel() {
        if let lastUpdateTime = viewModel.stationsData?.lastUpdateTime {
            lastUpdateLabel.text = "Last updated: \(lastUpdateTime)"
        } else {
            lastUpdateLabel.text = ""
        }
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stationsData?.stations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListCell,
              let station = viewModel.stationsData?.stations[indexPath.row] else {
            
            return UITableViewCell()
        }
        cell.set(station)
        
        return cell
    }
}
