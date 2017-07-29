//
//  ViewController.swift
//  BeerListing
//
//  Created by Felipe Marino on 28/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import UIKit

class BeersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    public var beers: [Beer] = []
    fileprivate var page = 0
    fileprivate var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem?.plain()
        automaticallyAdjustsScrollViewInsets = false
        activityIndicator.startAnimating()
        fetchBeers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func fetchBeers() {
        isLoading = true
        activityIndicator.isHidden = false
        BeersHTTPClient.getBeers(page: page + 1, success: { (beers) in
            guard beers.count > 0 else {
                return
            }
            
            self.beers += beers
            self.tableView.reloadData()
            self.page += 1
            
            self.fetchEnded()
        }) { (statusCode, response, error) in
            print("status code: \(statusCode), response: \(response), error: \(error)")
            //TODO: Treat error
            self.fetchEnded()
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.kShowDetail {
            if let destination = segue.destination as? DetailViewController {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    destination.beer = beers[selectedIndexPath.row]
                }
            }
        }
    }
    
    private func fetchEnded() {
        isLoading = false
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}

// MARK: - TableView Delegate
extension BeersViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
}

// MARK: - TableView DataSource
extension BeersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.kIdBeer, for: indexPath) as? BeerTableViewCell {
            
            let beer = beers[indexPath.row]
            //FIXME: Remove force_casts
            cell.name.text = beer.name
            cell.mainImage.load(stringUrl: beer.imageUrl!)
            cell.alcoholicStrength.text = (beer.alcoholicStrength?.description)! + "% abv"
            
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath.row > beers.count - 5) && !self.isLoading {
            fetchBeers()
        }
    }
}