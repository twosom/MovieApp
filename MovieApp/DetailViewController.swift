//
// Created by Hope on 2021/12/18.
//

import UIKit
import AVKit


class DetailViewController: UIViewController {

    var movieResult: MovieResult?

    var player: AVPlayer?

    @IBOutlet
    var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .systemFont(ofSize: 24, weight: .light)
            titleLabel.textColor = .black.withAlphaComponent(0.7)
        }
    }

    @IBOutlet
    var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .systemFont(ofSize: 16, weight: .light)
        }
    }

    @IBOutlet
    var movieContainer: UIView!

    override
    func viewDidLoad() {
        super.viewDidLoad()

        guard let title: String = movieResult?.title else {
            return
        }
        titleLabel.text = title
        guard let description: String = movieResult?.description else {
            return
        }
        descriptionLabel.text = description
    }

    /**
     실제로 디바이스의 크기값이나 위치값을 가져오는 순간
     - Parameter animated:
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let urlString: String = movieResult?.previewUrl else {
            return
        }
        player?.pause()
        makePlayerAndPlay(urlString: urlString)
    }

    func makePlayerAndPlay(urlString: String) {
        guard let url = URL(string: urlString) else {return}

        player = AVPlayer(url: url)
        let playerLayer: AVPlayerLayer = AVPlayerLayer(player: player)

        movieContainer.layer.addSublayer(playerLayer)
        playerLayer.frame = movieContainer.bounds

        player?.play()
    }

    @IBAction
    func play(_ sender: UIButton) {
        player?.play()
    }


    @IBAction
    func stop(_ sender: UIButton) {
        player?.pause()
    }

    @IBAction
    func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
