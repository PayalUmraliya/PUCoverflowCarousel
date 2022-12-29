//
//  ViewController.swift
//  PUCoverFlow
//
//  Created by Payal Umraliya on 29/12/22.
//
import UIKit
import SDWebImage
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var vwactions: UIView!

    @IBOutlet weak var btncomment: UIButton!
    @IBOutlet weak var btnlike: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var items = [Character]()
    var timer = Timer()
    fileprivate var currentPage: Int = 0 {
        didSet {
            self.vwactions.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.vwactions.alpha = 1
               
            }
        }
    }

    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! PUCoverFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        print("Page : \(pageSize)")
        return pageSize
    }
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        self.collectionView.isPagingEnabled = true
        self.collectionView.register(UINib(nibName: "CarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCollectionViewCell")
        self.setupLayout()
        loadDataAtCenter(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.loadDataAtCenter()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func loadDataAtCenter( _ isShimmer:Bool = false)
    {
        self.currentPage = 0
        if isShimmer
        {
           
            self.items = self.createShimmerItems()
            self.timer.invalidate()
            self.vwactions.isHidden = true
            self.collectionView.reloadData()
            self.collectionView.startShimmeringEffect()
        }
        else
        {
            self.items = self.createItems()
            self.vwactions.isHidden = false
            self.collectionView.reloadData()
            self.collectionView.stopShimmeringEffect()
            self.startTimer()
        }
        let indexPath = IndexPath(item: self.currentPage + 1, section: 0)
        self.currentPage = self.currentPage + 1
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    fileprivate func setupLayout()
    {
        self.collectionView.backgroundColor = UIColor.clear
        self.vwactions.layer.cornerRadius = self.vwactions.frame.size.height / 2
        self.vwactions.layer.borderColor = UIColor.lightGray.cgColor
        self.vwactions.layer.borderWidth = 0.8
        
        let layout = self.collectionView.collectionViewLayout as! PUCoverFlowLayout
        let padding = 10.0
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - padding)  / 1.5, height: (self.collectionView.frame.size.width  - padding) / 1.2 )
        layout.spacingMode = PUCoverFlowLayoutSpacingMode.overlap(visibleOffset: 120)
        layout.sideItemScale = 0.8
    }
    
    fileprivate func createItems() -> [Character] {
       
        let characters = [
            Character(imageName: "https://picsum.photos/id/11/2500/1667", name: "fishes", likecount: "20",commentcount:"10",title: "1.Five tips for a low-carb diet",subtitle: "It’s important to take breaks for mental health.The Pomodoro Technique is a time management system that encourages people",tag: "Physical wellbeing"),
            Character(imageName: "https://picsum.photos/id/5/5000/3334", name: "fishes", likecount: "30",commentcount:"13",title: "2.Meditation techniques for beginner",subtitle: "It’s important to take breaks for mental health.The Pomodoro Technique is a time management system that encourages people",tag: "Active days at home"),
            Character(imageName: "https://picsum.photos/id/6/5000/3333", name: "fishes", likecount: "210",commentcount:"60",title: "3.Stay fit, run 5k daily",subtitle: "your first time using Carthage in the project, you'll need to go through some additional steps as explained", tag: "Runners"),
            Character(imageName: "https://picsum.photos/id/7/4728/3168", name: "fishes", likecount: "740",commentcount:"68",title: "4.Travel together and healthy fitness",subtitle: "It’s important to take breaks for mental health.The Pomodoro Technique is a time management system that encourages people",tag: "Travelling"),
            Character(imageName: "https://picsum.photos/id/8/5000/3333", name: "fishes", likecount: "20",commentcount:"150",title: "5.Food choices makes difference in live",subtitle: "It’s important to take breaks for mental health.The Pomodoro Technique is a time management system that encourages people",tag: "Exercising"),
            Character(imageName: "https://picsum.photos/id/9/5000/3269", name: "fishes", likecount: "12",commentcount:"6",title: "6.Attempot to recover constarinta of your body",subtitle: "It’s important to take breaks for mental health.The Pomodoro Technique is a time management system that encourages people",tag: "Consultations")
        ]
        return characters
    }
    
    fileprivate func createShimmerItems() -> [Character] {
       
        let characters = [
            Character(imageName: "", name: "", likecount: "",commentcount:"",title: "",subtitle: "",tag: ""),
            Character(imageName: "", name: "", likecount: "",commentcount:"",title: "",subtitle: "",tag: ""),
            Character(imageName: "", name: "", likecount: "",commentcount:"",title: "",subtitle: "",tag: "")
        ]
        return characters
    }

    // MARK: - Card Collection Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int.max//items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CarouselCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCollectionViewCell", for: indexPath) as! CarouselCollectionViewCell
        cell.image.layer.masksToBounds = true
        cell.image.layer.cornerRadius = 10
        cell.image.clipsToBounds = true
        let character = items[indexPath.row % items.count ]
        cell.lbltitle.text = character.title
        cell.lbldescr.text = character.subtitle
        cell.lbltag.text = character.tag
        if character.imageName != ""
        {
            cell.image.sd_setImage(with: URL(string: character.imageName), placeholderImage: UIImage(named: character.name), context: .none)
            cell.image.backgroundColor = UIColor.clear
            self.btnlike.setTitle(character.likecount, for: .normal)
            self.btncomment.setTitle(character.commentcount, for: .normal)
            self.vwactions.alpha = 1
        }
        else
        {
            self.vwactions.alpha = 0
            cell.image.image = nil
            cell.image.backgroundColor = UIColor.gray
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            
            cell.layoutIfNeeded()
        })
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = items[indexPath.row % items.count ]
        let alert = UIAlertController(title: character.tag, message: character.subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! PUCoverFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        timer.invalidate()
        startTimer()
       
    }
    //MARK: - Auto Scroll
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true);
        }
    
    @objc func scrollAutomatically(_ timer1: Timer)
    {
        let scrollPosition: UICollectionView.ScrollPosition = orientation.isPortrait ? .centeredHorizontally : .centeredHorizontally
        if currentPage < Int.max
            {
                let indexPath = IndexPath(item: currentPage + 1, section: 0)
         
                self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
                currentPage = currentPage + 1
            }
            else
            {
                if items.count > 1
                {
                    let indexPath = IndexPath(item: 1, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
                    currentPage = 0
                }
            }
    }
    //MARK: Orientation
    @objc fileprivate func rotationDidChange() {
        guard !orientation.isFlat else { return }
        let layout = self.collectionView.collectionViewLayout as! PUCoverFlowLayout
        let direction: UICollectionView.ScrollDirection = orientation.isPortrait ? .horizontal : .horizontal
        layout.scrollDirection = direction
        if currentPage > 0 {
            let indexPath = IndexPath(item: currentPage, section: 0)
            let scrollPosition: UICollectionView.ScrollPosition = orientation.isPortrait ? .centeredHorizontally : .centeredHorizontally
            self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
        }
    }
}
extension UIView
{
        func startShimmeringEffect() {
            let light = UIColor.white.cgColor
            let alpha = UIColor(red: 206/255, green: 10/255, blue: 10/255, alpha: 0.7).cgColor
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
            gradient.colors = [light, alpha, light]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0,y: 0.525)
            gradient.locations = [0.35, 0.50, 0.65]
            self.layer.mask = gradient
            let animation = CABasicAnimation(keyPath: "locations")
            animation.fromValue = [0.0, 0.1, 0.2]
            animation.toValue = [0.8, 0.9,1.0]
            animation.duration = 1.5
            animation.repeatCount = HUGE
            gradient.add(animation, forKey: "shimmer")
        }
        func stopShimmeringEffect() {
            self.layer.mask = nil
        }
}
                            

