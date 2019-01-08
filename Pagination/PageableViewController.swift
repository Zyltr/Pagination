import UIKit

class PageableViewController: UIViewController, Pageable {

    @IBOutlet weak var emojiLabel: UILabel!
    
    var pageValue : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emojiLabel.text = pageValue
    }

}
