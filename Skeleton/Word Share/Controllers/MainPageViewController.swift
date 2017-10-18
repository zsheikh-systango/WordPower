//
//  MainPageViewController.swift
//  Word Share
//
//  Created by Best Peers on 18/10/17.
//  Copyright © 2017 www.Systango.Skeleton. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class MainPageViewController: UIPageViewController, UIPageViewControllerDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPageTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WordCollectionViewCell
        cell.textLabel.text = arrPageTitle[indexPath.row] as? String
        
        if (indexPath.row == 0){
            cell.textLabel.textColor = UIColor.blue
        }
        else{
            cell.textLabel.textColor = UIColor.lightGray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for cell in collectionView.visibleCells {
            (cell as! WordCollectionViewCell).textLabel.textColor = UIColor.lightGray
        }
        if let cell = collectionView.cellForItem(at: indexPath) as! WordCollectionViewCell? {
            cell.textLabel.textColor = UIColor.blue
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4, height: 50)
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        let navigationBarHeight: CGFloat = 20 + self.navigationController!.navigationBar.frame.height
        let rect = CGRect(
            origin: CGPoint(x: 0, y: navigationBarHeight),
            size: CGSize(width: UIScreen.main.bounds.size.width, height: 50)
        )
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WordCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        collectionView.layer.borderWidth = 1
        
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    var arrPageTitle: NSArray = NSArray()
    
    // Mark: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        arrPageTitle = ["Definitions", "Synonyms", "Antonyms", "Examples"];
        self.dataSource = self
        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: - Private Methods
    
    private func setupUI() {
        self.navigationItem.title = "Word Power"
        navigationController?.navigationBar.backgroundColor = UIColor(red:0.97, green:0.44, blue:0.12, alpha:1.00)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(MainPageViewController.saveButtonTapped(sender:)))
        
        view.addSubview(collectionView)
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> PageContentViewController{
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        pageContentViewController.strTitle = "\(arrPageTitle[index])"
        pageContentViewController.pageIndex = index
        pageContentViewController.wordInfoType = index == 0 ? .definitions : index == 1 ? .synonyms : index == 2 ? .antonyms : index == 3 ? .examples : .hindiTranslation
        return pageContentViewController
    }
    
    func hideExtensionWithCompletionHandler(completion:@escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.20, animations: {
            
            self.navigationController!.view.transform = CGAffineTransform(translationX: 0, y: self.navigationController!.view.frame.size.height)
        }, completion: completion)
    }
    
    // Mark: - IBActions Methods
    
    @objc func saveButtonTapped(sender: UIBarButtonItem) {
        self.hideExtensionWithCompletionHandler(completion: { (Bool) -> Void in
            self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
        })
    }
    
    // Mark: - DataSource Methods
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1
        return getViewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if (index == NSNotFound)
        {
            return nil;
        }
        index += 1
        if (index == arrPageTitle.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
    }

}

private extension MainPageViewController {
    struct Identifiers {
        static let DeckCell = "deckCell"
    }
}
