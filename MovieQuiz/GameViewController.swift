
import UIKit
import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet weak var viSoundbar: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet var btOptions: [UIButton]!
    @IBOutlet weak var imageQuiz: UIImageView!
    @IBOutlet weak var viTimer: UIView!
    
    var player: AVAudioPlayer!
    var quizManager = QuizManger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        quizManager.validateAnswer(sender.title(for: .normal)!)
        getNewRound()
    }
    
    @IBAction func showHideSoundBar(_ sender: UIButton) {
        viSoundbar.isHidden = !viSoundbar.isHidden
    }
    
    @IBAction func changeMusciStatus(_ sender: Any) {
        
    }
    
    @IBAction func changeMusicTime(_ sender: UISlider) {
        
    }
}

extension GameViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        imageQuiz.image = UIImage(named: "movieSoundPause")
    }
}
