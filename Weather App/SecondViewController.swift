//
//  SecondViewController.swift
//  Weather App
//
//  Created by Geemakun Storey on 2016-09-26.
//  Copyright © 2016 geemakunstorey@storeyofgee.com. All rights reserved.
//

import UIKit

class SecondViewController: UITableViewController{
    
    var coordinate: Location?
    var cities: [Location] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var darkSkyLogo: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "World"
        tableView.delegate = self
        tableView.dataSource = self
        
        // Imageview gesture recoginzer
        let imageView = darkSkyLogo
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector((imageTapped(img:))))
        imageView!.isUserInteractionEnabled = true
        imageView!.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(img: AnyObject) {
        showAlert("Open Safari?", message: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! DetailCityViewController
                let city = locations[(indexPath as NSIndexPath).row]
                let cityString = city.title
                controller.City = cityString!
                controller.Latitude = city.latitude
                controller.Longitude = city.longitude
            }
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        
        let city = locations[(indexPath as NSIndexPath).row]
        cell.cityLabel.text = city.title
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    func showAlert(_ title: String, message: String?, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: "Open Safari?", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            if let url = NSURL(string: "https://darksky.net/poweredby/") {
                UIApplication.shared.openURL(url as URL)
            }
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
    }
    
    
    

}

