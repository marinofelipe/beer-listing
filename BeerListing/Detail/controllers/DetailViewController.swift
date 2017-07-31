//
//  DetailViewController.swift
//  BeerListing
//
//  Created by Felipe Marino on 28/07/17.
//  Copyright © 2017 Felipe Marino. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    public var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = beer?.name
        automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func didTapShare(_ sender: Any) {
        share(withInitialText: "", image: beer?.image)
    }
}

// MARK: - TableView Delegate
extension DetailViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
}

// MARK: - TableView DataSource
extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.kIdDetail, for: indexPath) as? DetailTableViewCell {
            if let beer = beer {
                if let image = beer.image {
                    cell.mainImage.image = image
                }
                cell.name.text = beer.name.uppercased()
                cell.alcoholicStrength.text = beer.alcoholicStrength.description + "%"
                cell.scaleOfBitterness.text = beer.scaleOfBitterness.description
                cell.tagline.text = beer.tagline
                cell.mainDescription.text = beer.mainDescription

                return cell
            }
        }
        
        return cell
    }
}
