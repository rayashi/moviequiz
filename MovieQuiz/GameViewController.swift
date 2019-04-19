
import UIKit
import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet weak var viSoundbar: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet var btOptions: [UIButton]!
    @IBOutlet weak var imageQuiz: UIImageView!
    @IBOutlet weak var viTimer: UIView!
    @IBOutlet weak var btnPlayPauseBackground: UIButton!
    
    var player: AVAudioPlayer!
    var quizManager = QuizManger()
    var itemPLayer: AVPlayerItem!
    var backgroundPlayer: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgroundMusic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quizManager = QuizManger()
        getNewRound()
        startTimer()
    }
    
    func startTimer() {
        viTimer.frame.size.width = view.frame.size.width
        UIView.animate(withDuration: 60.0, delay: 0.0, options: .curveLinear, animations: {
            self.viTimer.frame.size.width = 0
        }) { success in
            self.gameOver()
        }
    }
    
    func gameOver() {
        performSegue(withIdentifier: "segue", sender: nil)
        player.stop()
    }
    
    @IBAction func play(){
        imageQuiz.image = UIImage(named: "movieSound")
        let url = Bundle.main.url(forResource: "quote\(quizManager.round!.quiz.number)", withExtension: "mp3")!
        player = try! AVAudioPlayer(contentsOf: url)
        player.delegate = self
        player.volume = 1
        player.play()
    }
    
    func getNewRound() {
        let round = quizManager.generateRandomQuiz()
        for i in 0..<round.options.count {
            btOptions[i].setTitle(round.options[i].name, for: .normal)
        }
        play()
    }
    
    func playBackgroundMusic() {
        let url = Bundle.main.url(forResource: "MarchaImperial", withExtension: "mp3")!
        itemPLayer = AVPlayerItem(url: url)
        backgroundPlayer = AVPlayer(playerItem: itemPLayer)
        backgroundPlayer.volume = 0.1
        backgroundPlayer.play()
        backgroundPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: nil) { time in
            let percent = time.seconds / self.itemPLayer.duration.seconds
            self.slider.setValue(Float(percent), animated: true)
        }
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        quizManager.validateAnswer(sender.title(for: .normal)!)
        getNewRound()
    }
    
    @IBAction func showHideSoundBar(_ sender: UIButton) {
        if viSoundbar.isHidden {
            self.viSoundbar.isHidden = false
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
                self.viSoundbar.alpha = 1
            }) { success in
                self.viSoundbar.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
                self.viSoundbar.alpha = 0
            }) { success in
                self.viSoundbar.isHidden = true
            }
        }
    }
    
    @IBAction func changeMusciStatus(_ sender: UIButton) {
        if backgroundPlayer.timeControlStatus == .paused {
            backgroundPlayer.play()
            sender.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            backgroundPlayer.pause()
            sender.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    @IBAction func changeMusicTime(_ sender: UISlider) {
        backgroundPlayer.seek(to: CMTime(seconds: Double(sender.value) * itemPLayer.duration.seconds, preferredTimescale: 1))
    }
}

extension GameViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        imageQuiz.image = UIImage(named: "movieSoundPause")
    }
}
