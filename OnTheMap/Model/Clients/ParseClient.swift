//
//  ParseClient.swift
//  OnTheMap
//
//  Created by David Koch on 21.11.22.
//

import Foundation

class ParseClient {
    
    struct Auth {
        static var sessionId = ""
        static var objectId = ""
        static var accountKey = ""
        static var firstName = "Fred"
        static var lastName = "Müller"
    }
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        case limit(Int)
        case putRequest
        var stringValue: String{
            switch self{
            case .limit(let value): return Endpoints.base + "?limit=\(value)&order=-updatedAt"
            case .putRequest: return Endpoints.base + "/\(Auth.objectId)"
            }
                
        }
        
        var url: URL{
            return URL(string: stringValue)!
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        let request = URLRequest(url: Endpoints.limit(200).url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let locationResponse = try decoder.decode(StudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(locationResponse.results, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
                
            }
        }
        task.resume()
    }
    
    
    class func POSTStudentLocation(location: Location, completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: URL(string: Endpoints.base)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            request.httpBody = try JSONEncoder().encode(location)
        } catch {
            DispatchQueue.main.async {
                completion(false, error)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            do{
                let locationResponse = try JSONDecoder().decode(LocationResponse.self, from: data)
                Auth.objectId = locationResponse.objectId
                completion(true, nil)
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func PUTStudentLocation(location: Location, completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.putRequest.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            request.httpBody = try JSONEncoder().encode(location)
        } catch {
            DispatchQueue.main.async {
                completion(false, error)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            do{
                let locationResponse = try JSONDecoder().decode(PutResponse.self, from: data)
                completion(true, nil)
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }

}
