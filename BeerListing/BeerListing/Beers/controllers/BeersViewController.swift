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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        activityIndicator.startAnimating()
//        fetch()
        automaticallyAdjustsScrollViewInsets = false
        mockBeers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //FIXME: Remove mocked data
    private func mockBeers() {
        for _ in 0..<10 {
            beers.append(Beer(mainImage: UIImage(named: "image-beer")!, name: "Felipe Marino IPA Beer", alcoholicStrength: "4.8", tagline: "IPA", scaleOfBitterness: "4.9", mainDescription: "Felipe Marino IPA best beer on market you should prove it. Lorem ipsum, Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum"))
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.kShowDetail {
            if let destination = segue.destination as? DetailViewController {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    destination.beer = beers[selectedIndexPath.row]
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row: \(indexPath.row)")
        
        self.performSegue(withIdentifier: Constants.Segue.kShowDetail, sender: self)
//        self.performSegue(withIdentifier: Constants.Segue.kShowDetail, sender: tableView.cellForRow(at: indexPath))
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
            cell.name.text = beer.name
            cell.mainImage.image = beer.mainImage
            cell.alcoholicStrength.text = beer.alcoholicStrength
            
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        if indexPath.row >= (beers.count - 10) && !self.isLoading {
//            self.fetch()
//        }
    }
}

// MARK: - ScrollView Delegate
extension BeersViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            
//                        fetch()
//            tableView.reloadData()
        }
    }
}
