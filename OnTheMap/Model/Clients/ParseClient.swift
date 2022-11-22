//
//  ParseClient.swift
//  OnTheMap
//
//  Created by David Koch on 21.11.22.
//

import Foundation

class ParseClient {
    
    private struct Auth {
        static var sessionId = ""
    }
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        case limit(Int)
        
        var stringValue: String{
            switch self{
            case .limit(let value): return Endpoints.base + "?limit=\(value)"
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
    
    /*
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
    }*/
}
