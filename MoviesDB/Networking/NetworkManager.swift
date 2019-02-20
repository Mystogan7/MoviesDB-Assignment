//
//  NetworkManager.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import Foundation

enum StatusCode: Int {
    case success = 200
    case failure = 300
}

class NetworkManager {
    
    static var shared: NetworkManager = NetworkManager()
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    
    func start<Request: RequestProtocol>(_ request: Request) {
        dataTask?.cancel()
        guard let requestURL = URL(string: request.path.absolutePath) else {
            dataTask?.cancel()
            return
        }
        dataTask = defaultSession.dataTask(with: requestURL) { data, response, error in
                defer { self.dataTask = nil }
            let response = response as? HTTPURLResponse
            switch response?
                .statusCode {
            case StatusCode.success.rawValue: break
                // get a dictionary from data and append it to request completion.
                //            let result: Result<Request.Model, Request.Error> = Result.success(<#ResponseModel#>)
                //            request.completion(result!)
            case StatusCode.failure.rawValue: break
                //            let result: Result<Request.Model, Request.Error> = Result.success(<#ResponseModel#>)
                //            request.completion(result!)
            default:
                break

            }
        }
        dataTask?.resume()
    }
    
    private func parseResponse(from data: Data) -> JSON? {
        var response: JSON?
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return nil
        }
        return response
    }
    
    
    
    
}
