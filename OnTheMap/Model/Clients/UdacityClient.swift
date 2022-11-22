//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by David Koch on 21.11.22.
//

import Foundation

class UdacityClient {
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case signUpURL
        case session
        case getUser
        var stringValue: String{
            switch self{
            case .session: return Endpoints.base + "/session"
            case .signUpURL: return "https://auth.udacity.com/sign-up?next=https://learn.udacity.com"
            case .getUser: return Endpoints.base + "/users/\(ParseClient.Auth.accountKey)"
                
            }
        }
        var url: URL{
            return URL(string: stringValue)!
        }
    }
    
    class func login(user: SessionRequest, completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        do{
            request.httpBody = try JSONEncoder().encode(["udacity": user.udacity])
        } catch {
            DispatchQueue.main.async {
                completion(false, error)
            }
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            do{
                let sessionResponse = try JSONDecoder().decode(SessionResponse.self, from: newData)
                ParseClient.Auth.sessionId = sessionResponse.session.id
                ParseClient.Auth.accountKey = sessionResponse.account.key
                getUserData { success, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            completion(false, error)
                        }
                        return
                    }
                    if success {
                        DispatchQueue.main.async {
                            completion(sessionResponse.account.registered, nil)
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            completion(false, error)
                        }
                    }
                }
            } catch {
                do{
                    let sessionResponse = try JSONDecoder().decode(SessionErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(false, sessionResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                    
                }
            }
            
        }
        task.resume()
    }
    
    class func logout(completion: @escaping () -> Void){
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            DispatchQueue.main.async{
                completion()
            }
            
        }
        task.resume()
    }
    
    class func getUserData(completion: @escaping (Bool, Error?) -> Void){
        let request = URLRequest(url: Endpoints.getUser.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            do{
                let userData = try JSONDecoder().decode(StudentGetResponse.self, from: newData)
                ParseClient.Auth.firstName = userData.firstName
                ParseClient.Auth.lastName = userData.lastName
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
      
            }
        }
        task.resume()
        
    }
    
}
