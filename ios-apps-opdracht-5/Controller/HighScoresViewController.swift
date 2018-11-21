import UIKit

class HighScoresViewController: UITableViewController {

    var highScores: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        
        if let highScores = defaults.dictionary(forKey: "highScores") {
            highScores.forEach({ highScore in
                self.highScores.append(highScore.key + " - " + String(highScore.value as! Int))
            })
        }
        
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highscoreCell", for: indexPath)
        
        cell.textLabel?.text = highScores[indexPath.row]

        return cell
    }
}
