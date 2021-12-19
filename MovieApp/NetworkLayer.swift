//
// Created by Desire L on 2021/12/19.
//

import UIKit


enum MovieRequestType {
    case MOVIE_SEARCH(keyword: String)
    case LOAD_IMAGE(imageUrl: String)
}

enum MovieError: Error {
    case URL_NOT_FOUND
}

class NetworkLayer {

    let configuration = URLSessionConfiguration.default

    let defaultUrl: String = "https://itunes.apple.com/search"

    typealias NetworkCompletion = (Data, HTTPURLResponse, Error?) -> Void


    func request(type: MovieRequestType, completion: @escaping NetworkCompletion) {
        do {
            let session = URLSession(configuration: configuration)
            let request = try buildRequest(type: type)
            session.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse, let data = data else {
                    return
                }

                print("### HTTP STATUS = \(response.statusCode)")

                completion(data, response, error)
            }.resume()

            session.finishTasksAndInvalidate()
        } catch {
            print(error)
        }


    }


    private func buildRequest(type: MovieRequestType) throws -> URLRequest {
        switch type {
        case .MOVIE_SEARCH(keyword: let keywrod):
            guard var urlComponents = URLComponents(string: self.defaultUrl) else {
                throw MovieError.URL_NOT_FOUND
            }

            let queryItems = [
                URLQueryItem(name: "country", value: "KR"),
                URLQueryItem(name: "media", value: "movie"),
                URLQueryItem(name: "term", value: keywrod)
            ]

            urlComponents.queryItems = queryItems

            guard let url = urlComponents.url else {
                throw MovieError.URL_NOT_FOUND
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        case .LOAD_IMAGE(imageUrl: let imageUrl):

            guard let url = URL(string: imageUrl) else {
                throw MovieError.URL_NOT_FOUND
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        }
    }


}
