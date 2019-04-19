import Foundation

typealias Round = (quiz: Quiz, options: [Option])

class QuizManger {
    var quizes: [Quiz] = []
    var options: [Option] = []
    var score: Int = 0
    var round: Round?
    
    init() {
        let quizesURL = Bundle.main.url(forResource: "quizes", withExtension: "json")!
        let optionsURL = Bundle.main.url(forResource: "options", withExtension: "json")!
        do {
            let quizesData = try Data(contentsOf: quizesURL)
            quizes = try JSONDecoder().decode([Quiz].self, from: quizesData)
            let optionsData = try Data(contentsOf: optionsURL)
            options = try JSONDecoder().decode([Option].self, from: optionsData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func generateRandomQuiz() -> Round {
        let quizIndex = Int(arc4random_uniform(UInt32(quizes.count)))
        let quiz = quizes[quizIndex]
        var optionsIndex: Set<Int> = [quizIndex]
        while optionsIndex.count < 4 {
            optionsIndex.insert(Int(arc4random_uniform(UInt32(quizes.count))))
        }
        let opts = optionsIndex.map{options[$0]}
        round = (quiz, opts)
        return round!
    }
    
    func validateAnswer(_ answer: String) {
        guard let round = round else { return }
        if answer == round.quiz.name {
            score += 1
        }
    }
}


struct Quiz: Codable {
    let name: String
    let number: Int
}

struct Option: Codable {
    let name: String
}
