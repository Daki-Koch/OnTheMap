//
//  Location.swift
//  OnTheMap
//
//  Created by David Koch on 22.11.22.
//

import Foundation


struct Location: Codable, Equatable{
    //an extra (optional) key used to uniquely identify a StudentLocation; should be populated using Udacity account id.
    let uniqueKey: String
    //the first name of the student which matches their Udacity profile first name OR an anonymized name hardcoded in the app
    let firstName: String
    //the last name of the student which matches their Udacity profile last name OR an anonymized name hardcoded in the app
    let lastName: String
    //the location string used for geocoding the student location
    let mapString: String
    //the URL provided by the student
    let mediaURL: String
    //the latitude of the student location (ranges from -90 to 90)
    let latitude: Float
    //the longitude of the student location (ranges from -180 to 180)
    let longitude: Float
}
