import Foundation

import UIKit

protocol Pageable where Self : UIViewController {
    
    associatedtype Value : Any
    var pageValue : Value? { get set }
    
}

class PageModelController<Page : Pageable> : NSObject, UIPageViewControllerDataSource {
    
    private let identifier: String
    private let pageLimit: Int
    private var presentationIndex: Int
    
    /* Is cleared when all pages loaded */
    private var values: [Page.Value]
    
    private var viewControllers: [Int : Page]
    private let storyboard: UIStoryboard
    
    
    init? (storyboard: UIStoryboard?, viewControllerIdentifier: String, values: [Page.Value]) {
        guard let storyboard = storyboard else {
            return nil
        }
        
        self.storyboard = storyboard
        self.values = values
        self.pageLimit = values.count
        self.identifier = viewControllerIdentifier
        self.presentationIndex = 0
        self.viewControllers = [:]
    }
    
    var firstViewController: Page? {
        guard let firstViewController = self.viewControllerAtIndex(0), self.pageLimit > 0 else {
            return nil
        }
        
        return firstViewController
    }
    
    private func viewControllerAtIndex(_ index: Int) -> Page? {
        if self.viewControllers.keys.contains(index) {
            return self.viewControllers[index]
        }
        
        guard var viewController = self.storyboard.instantiateViewController(withIdentifier: self.identifier) as? Page else {
            preconditionFailure("ViewController with identifier \(self.identifier) could not be found in the Storyboard \(self.storyboard)")
        }
        
        guard !self.values.isEmpty else {
            return nil
        }
        
        viewController.pageValue = self.values[index]
        viewController.view.tag = index
        
        self.viewControllers[index] = viewController
        
        if self.viewControllers.count == self.pageLimit {
            self.values.removeAll()
        }
        
        return viewController
    }
    
    private func indexOfViewController(_ viewController : Page) -> Int {
        return viewController.view.tag
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = self.indexOfViewController(viewController as! Page)
        let beforeIndex = currentIndex - 1 < 0 ? self.pageLimit - 1 : currentIndex - 1
        
        self.presentationIndex = beforeIndex
        
        return currentIndex != beforeIndex ? self.viewControllerAtIndex(beforeIndex) : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = self.indexOfViewController(viewController as! Page)
        let afterIndex = currentIndex + 1 < self.pageLimit ? currentIndex + 1 : 0
        
        self.presentationIndex = afterIndex
        
        return currentIndex != afterIndex ? self.viewControllerAtIndex(afterIndex) : nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageLimit
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.presentationIndex
    }
    
}
