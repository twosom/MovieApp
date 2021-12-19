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

    let decoder: JSONDecoder = JSONDecoder()

    let isoFormatter: ISO8601DateFormatter = ISO8601DateFormatter()

    let koreanFormatter: DateFormatter = DateFormatter()

    @IBOutlet
    var searchBar: UISearchBar!


    @IBOutlet
    var movieTableView: UITableView!

    override
    func viewDidLoad() {
        super.viewDidLoad()
        koreanFormatter.dateFormat = "yyyy년 MM월 dd일"
        movieTableView.delegate = self
        movieTableView.dataSource = self
        searchBar.delegate = self
    }


    func searchMovie(keyword: String) {
        networkLayer.request(type: .MOVIE_SEARCH(keyword: keyword)) { data, response, error in
            do {
                self.movieModel = try self.decoder.decode(MovieModel.self, from: data)
                DispatchQueue.main.async {
                    self.movieTableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }

    func loadImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        networkLayer.request(type: .LOAD_IMAGE(imageUrl: imageUrl)) { data, response, error in
            completion(UIImage(data: data))
            return
        }
        completion(nil)
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

        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return MovieCell()
        }

        guard let movie = movieModel?.results[indexPath.row] else {
            return movieCell
        }

        if let title = movie.title {
            movieCell.titleLabel.text = title
        }

        if let description = movie.description {
            movieCell.descriptionLabel.text = description
        }

        if let imageUrl = movie.imageUrl {
            loadImage(imageUrl: imageUrl) { image in
                DispatchQueue.main.async {
                    movieCell.imageView?.image = image
                }
            }
        }

        if let price = movie.price, let currency = movie.currency {
            movieCell.priceLabel.text = "\(price) \(currency)"
        }

        if let releaseDate = movie.releaseDate {
            guard let date: Date = isoFormatter.date(from: releaseDate) else {
                return movieCell
            }

            movieCell.dateLabel.text = koreanFormatter.string(from: date)
        }


        return movieCell
    }

    /**
     선택 되었을 경우
     - Parameters:
       - tableView:
       - indexPath:
     */
    public func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let detailVC = UIStoryboard(name: "DetailViewController", bundle: nil)
                .instantiateViewController(identifier: "DetailViewController") as? DetailViewController, let movie = movieModel?.results[indexPath.row] else {
            return
        }


        detailVC.movieResult = movie
        present(detailVC, animated: true)
    }

    public func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView,
                          estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}


extension ViewController: UISearchBarDelegate {

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword: String = searchBar.text else {
            return
        }
        print(keyword)

        searchMovie(keyword: keyword)
        view.endEditing(true)
    }
}

