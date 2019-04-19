
import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var viSoundbar: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet var btOptions: [UIButton]!
    @IBOutlet weak var imageQuiz: UIImageView!
    
    var quizManager = QuizManger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quizManager = QuizManger()
        getNewRound()
    }
    
    func getNewRound() {
        let round = quizManager.generateRandomQuiz()
        for i in 0..<round.options.count {
            btOptions[i].setTitle(round.options[i].name, for: .normal)
        }
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        quizManager.validateAnswer(sender.title(for: .normal)!)
        getNewRound()
    }
    
    @IBAction func showHideSoundBar(_ sender: UIButton) {
    }
    
    @IBAction func changeMusciStatus(_ sender: Any) {
    }
    
    @IBAction func changeMusicTime(_ sender: UISlider) {
    }
}
