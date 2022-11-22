//
//  TableViewController.swift
//  OnTheMap
//
//  Created by David Koch on 21.11.22.
//

import UIKit

class TableViewController: UITableViewController{
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.getStudentLocations { results, error in
            StudentLocationData.sharedInstance().results = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UdacityClient.logout(completion: handleLogoutResponse)
    }
    
    @IBAction func addLocation(_ sender: Any) {
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        ParseClient.getStudentLocations { results, error in
            if let error = error {
                self.showFailure(message: error.localizedDescription, title: "Error")
            }
            StudentLocationData.sharedInstance().results = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func handleLogoutResponse(){
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationData.sharedInstance().results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "udacityStudentCell")!
        
        cell.textLabel?.text = StudentLocationData.sharedInstance().results[indexPath.row].firstName + " " + StudentLocationData.sharedInstance().results[indexPath.row].lastName
        cell.detailTextLabel?.text = StudentLocationData.sharedInstance().results[indexPath.row].mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        if let toOpen = StudentLocationData.sharedInstance().results[indexPath.row].mediaURL {
            if let url = URL(string: toOpen){
                app.open(url)
            } else {
                showFailure(message: "Failed to open URL, please enter valid URL", title: "Failed to open URL")
            }
        }
    }
    
}


