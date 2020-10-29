//
//  CountryDropDownViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 08/10/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit

class CountryDropDownViewController: UIViewController,UITableViewDelegate ,UITableViewDataSource {
        
    @IBOutlet weak var Popupview: UIView!
    
    
    var delegate:dropdown!
    @IBOutlet weak var tableView: UITableView!
    var names: [String] = ["Albania", "Andorra", "Armenia",
            "Austria", "azerbaijan", "Belarus", "Belgium", "Bosnia", "Bulgaria", "Croatia", "Cyprus","Czechia"
            ,"Denmark","Estonia","Finland","France","Georgia","Germany","Greece","Hungary","Iceland",
            "Ireland","Italy","Kazakhstan","Kosovo","Latvia","Liechtenstein","Lithuania","Luxembourg",
            "Macedonia","Malta","Moldova","Monaco","Montenegro","Netherlands","Norway","Poland","Portugal",
            "Romaina","Russia","San Marino","Serbia","Slovakia","Slovenia","Spain","Sweden","Switzerland",
    "Turkey","Ukraine","United Kingdom"]
    override func viewDidLoad() {
        super.viewDidLoad()
           
           tableView.dataSource = self
           tableView.delegate = self
        
          // Apply radius to Popupview
           Popupview.layer.cornerRadius = 10
           Popupview.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
       
       // Returns count of items in tableView
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.names.count;
       }
       
       
       // Select item from tableView
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           print("Company Name : " + names[indexPath.row])
         
            Shared.shared.companyName = names[indexPath.row]
        delegate.clickCountry(countryName: names[indexPath.row])
        self.dismiss(animated: true)
//           let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//           let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//          self.present(newViewController, animated: true, completion: nil)
     
       }
       
       //Assign values for tableView
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
           cell.textLabel?.text = names[indexPath.row]
     
           return cell
       }



}
protocol dropdown {
    func clickCountry(countryName:String) 
}
