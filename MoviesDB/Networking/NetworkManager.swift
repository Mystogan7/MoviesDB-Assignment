//
//  NetworkManager.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import Foundation
import UIKit

enum ResultStatus {
    case success
    case failure
}

class NetworkManager {
    
    static var shared: NetworkManager = NetworkManager()
    
    private let defaultSession = URLSession(configuration: .default)
    private var task: URLSessionTask?
    private let caching: Caching = Caching()
    
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
                    } catch let error {
                        fatalError("\(error)")
                    }
                    
                case .failure:
                    requestResult = Result.failure(BaseError(error: "", errorCode: "", description: ""))
                    request.completion(requestResult)
                }
            }
        }
        task?.resume()
    }
    
    //This function is made specifically to load images and caching them.
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        task?.cancel()
        caching.load(key: url.absoluteString, completion: { [weak self] cachedData in
            if let data = cachedData, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                self!.task = self!.defaultSession.dataTask(with: url, completionHandler: { (data, _, error) in
                    guard let data = data, error == nil else {
                        return
                    }
                    if let image = UIImage(data: data) {
                        //Save to cache
                        self?.caching.save(data: data, key: url.absoluteString)
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    } else {
                        print("Error loading image at \(url)")
                    }
                })
                self?.task?.resume()
            }
        })
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
