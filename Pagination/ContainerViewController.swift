import UIKit

class ContainerViewController : UIViewController, UIPageViewControllerDelegate {
    
    @IBOutlet weak private var pageStackView: UIStackView!
    
    private var pageViewController: UIPageViewController!
    private var pageControl: UIPageControl!
    
    private var modelController : PageModelController<PageableViewController>!
    
    public var navigationOrientation  = UIPageViewController.NavigationOrientation.horizontal
    public var transitionStyle = UIPageViewController.TransitionStyle.pageCurl
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let values = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯"]
        self.modelController = PageModelController<PageableViewController>(storyboard: self.storyboard, viewControllerIdentifier: "Page", values: values)
        
        guard let first = self.modelController.firstViewController else {
            print("Failed to get first")
            return
        }
        
        self.pageViewController = UIPageViewController(transitionStyle: self.transitionStyle, navigationOrientation: self.navigationOrientation, options: nil)
        
        self.pageViewController.dataSource = self.modelController
        self.pageViewController.delegate = self
        self.pageViewController.setViewControllers([first], direction: .forward, animated: false, completion: nil)
        
        self.pageStackView.addArrangedSubview(self.pageViewController.view)
        self.addChild(self.pageViewController)
        
        self.pageControl = UIPageControl(frame: CGRect())
        self.pageControl.numberOfPages = values.count
        self.pageControl.currentPageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.8)
        self.pageControl.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.2)
        
        self.pageStackView.addArrangedSubview(self.pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished, completed else {
            return
        }
        
        self.pageControl.currentPage = self.pageControl.currentPage + 1 < self.pageControl.numberOfPages ? self.pageControl.currentPage + 1 : 0
    }
    
}
