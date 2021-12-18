//
//  ViewController.swift
//  MovieApp
//
//  Created by Desire L on 2021/12/16.
//
//

import UIKit


class ViewController: UIViewController {

    var movieModel: MovieModel?

    let networkLayer = NetworkLayer()

    @IBOutlet
    var searchBar: UISearchBar!


    @IBOutlet
    var movieTableView: UITableView!

    override
    func viewDidLoad() {
        super.viewDidLoad()

        movieTableView.delegate = self
        movieTableView.dataSource = self
        searchBar.delegate = self
    }

    /**
     URL 주소로 사진을 불러옵니다.
     - Parameters:
       - url: 이미지 URL
       - completion: 콜백
     */
    func loadImage(_ url: String, completion: @escaping (UIImage?) -> Void) {
        networkLayer.request(type: .LOAD_IMAGE(urlString: url)) { data, response, error in
            completion(UIImage(data: data))
            return
        }
        completion(nil)
    }

    func requestMovieAPI(keyword: String) {
        let queryItems = [
            URLQueryItem(name: "term", value: keyword),
            URLQueryItem(name: "country", value: "KR"),
            URLQueryItem(name: "media", value: "movie")
        ]

        networkLayer.request(type: .SEARCH_MOVIE(queries: queryItems)) { data, response, error in
            do {
                let movieModel: MovieModel = try JSONDecoder().decode(MovieModel.self, from: data)
                self.movieModel = movieModel

                DispatchQueue.main.async {
                    self.movieTableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }


}


//### PROTOCOL EXTENSION ###//
extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        movieModel?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell: MovieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return MovieCell()
        }

        guard let movie: MovieResult = movieModel?.results[indexPath.row] else {
            return movieCell
        }

        guard let title: String = movie.title else {
            return movieCell
        }
        movieCell.titleLabel.text = title

        guard let imageUrl: String = movie.imageUrl else {
            return movieCell
        }
        //TODO Load Image From URL

        loadImage(imageUrl) { image in
            DispatchQueue.main.async {
                movieCell.movieImageView.image = image
            }
        }

        guard let description: String = movie.description else {
            return movieCell
        }

        movieCell.descriptionLabel.text = description

        guard let price = movie.price, let currency = movie.currency else {
            return movieCell
        }

        movieCell.priceLabel.text = "\(price) \(currency)"

        guard let releaseDate = movie.releaseDate else {
            return movieCell
        }


        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: releaseDate) {
            let koreanFormatter = DateFormatter()
            koreanFormatter.dateFormat = "yyyy년 MM월 dd일"
            movieCell.dateLabel.text = koreanFormatter.string(from: date)
        }


        return movieCell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailVC: DetailViewController = UIStoryboard(name: "DetailViewController", bundle: nil)
                .instantiateViewController(identifier: "DetailViewController") as? DetailViewController else {
            return
        }

        guard let movie: MovieResult = movieModel?.results[indexPath.row] else {
            return
        }
        detailVC.movieResult = movie
        present(detailVC, animated: true)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}


extension ViewController: UISearchBarDelegate {

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestMovieAPI(keyword: searchBar.text ?? "")
    }
}

