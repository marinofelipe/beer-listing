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

        automaticallyAdjustsScrollViewInsets = false
        mockBeer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func mockBeer() {
        beer = Beer(mainImage: UIImage(named: "image-beer")!, name: "Felipe Marino IPA Beer", alcoholicStrength: "4.8", tagline: "IPA", scaleOfBitterness: "4.9", mainDescription: "Felipe Marino IPA best beer on market you should prove it. Lorem ipsum, Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum")
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
                cell.mainImage.image = beer.mainImage
                cell.name.text = beer.name
                cell.alcoholicStrength.text = beer.alcoholicStrength
                cell.scaleOfBitterness.text = beer.scaleOfBitterness
                cell.tagline.text = beer.tagline
                cell.mainDescription.text = beer.mainDescription

                return cell
            }
        }
        
        return cell
    }
}
