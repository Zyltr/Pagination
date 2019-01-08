import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var navOrientationControl: UISegmentedControl!
    @IBOutlet weak var transStyleControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ContainerViewController {
            destination.navigationOrientation = self.isEven(self.navOrientationControl.selectedSegmentIndex) ? .horizontal : .vertical
            destination.transitionStyle = self.transStyleControl.selectedSegmentIndex % 2 == 0 ? .pageCurl : .scroll
        }
    }

    private func isEven(_ integer: Int) -> Bool {
        return integer % 2 == 0
    }
}

