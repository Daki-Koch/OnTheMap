//
//  TableViewController.swift
//  OnTheMap
//
//  Created by David Koch on 21.11.22.
//

import UIKit

class TableViewController: UITableViewController{
    
    var studentLocations: [StudentLocation]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.getStudentLocations { results, error in
            self.studentLocations = results
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
            self.studentLocations = results
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
        return studentLocations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "udacityStudentCell")!
        
        cell.textLabel?.text = studentLocations![indexPath.row].firstName + studentLocations![indexPath.row].lastName
        cell.detailTextLabel?.text = studentLocations![indexPath.row].mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        if let toOpen = studentLocations?[indexPath.row].mediaURL {
            
            app.open(URL(string: toOpen)!)
            
        }
        
    }
    
}


