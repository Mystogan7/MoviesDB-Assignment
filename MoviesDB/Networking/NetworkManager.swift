//
//  NetworkManager.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import Foundation

enum ResultStatus {
    case success
    case failure
}

class NetworkManager {
    
    static var shared: NetworkManager = NetworkManager()
    
    let defaultSession = URLSession(configuration: .default)
    var task: URLSessionTask?
    
    func start<Request: RequestProtocol>(_ request: Request) {
        task?.cancel()
        guard let requestURL = URL(string: request.path.absolutePath) else {
            task?.cancel()
            return
        }
        task = defaultSession.dataTask(with: requestURL) { data, response, error in
                defer { self.task = nil }
            if let response = response as? HTTPURLResponse {
                let result = self.handleResponse(response)
                var requestResult: Result<Request.Model, Request.Error>
                switch result {
                case .success:
                    guard let responseData = data else {
                        return
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(json)
                        let model = try JSONDecoder().decode(request.responseModel.self, from: responseData)
                        requestResult = Result.success(model)
                        request.completion(requestResult)
                    } catch { }
                    
                case .failure:
                    requestResult = Result.failure(BaseError(error: "", errorCode: "", description: ""))
                    request.completion(requestResult)
                }
            }
        }
        task?.resume()
    }

    private func handleResponse(_ response: HTTPURLResponse) -> ResultStatus {
        switch response.statusCode {
        case 200:
            return .success
        case 401:
            return .failure
        default:
            return .failure
        }
    }
    
}
