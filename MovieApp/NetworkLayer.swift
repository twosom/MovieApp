//
// Created by Desire L on 2021/12/19.
//

import UIKit

enum MovieAPIType {
    case LOAD_IMAGE(urlString: String)
    case SEARCH_MOVIE(queries: [URLQueryItem])
}

enum MovieAPIError: Error {
    case BAD_URL

}

class NetworkLayer {
    private let defaultAPIUrl = "https://itunes.apple.com/search"
    typealias NetworkCompletion = (Data, HTTPURLResponse, Error?) -> Void
    private let sessionConfig = URLSessionConfiguration.default


    /**
     1. only url
     2. url + param
     */
    func request(type: MovieAPIType, completion: @escaping NetworkCompletion) {
        let session = URLSession(configuration: sessionConfig)

        do {
            let request: URLRequest = try buildRequest(type: type)
            session.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse, let data = data else {
                    return
                }
                print("###HTTP STATUS CODE = \(response.statusCode)")
                completion(data, response, error)
            }.resume()

            session.finishTasksAndInvalidate()
        } catch {
            print(error)
        }
    }


    private func buildRequest(type: MovieAPIType) throws -> URLRequest {
        switch type {
        case .LOAD_IMAGE(urlString: let urlString):
            guard let url = URL(string: urlString) else {
                throw MovieAPIError.BAD_URL
            }
            var request: URLRequest = URLRequest(url: url)
            request.httpMethod = "GET"
            return request

        case .SEARCH_MOVIE(queries: let queries):
            guard var components = URLComponents(string: defaultAPIUrl) else {
                throw MovieAPIError.BAD_URL
            }
            components.queryItems = queries
            guard let url = components.url else {
                throw MovieAPIError.BAD_URL
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        }
    }

}
