//
//  EndlessLoopView.swift
//  CollectionView轮播
//
//  Created by sunhua_com on 16/5/10.
//  Copyright © 2016年 sunhua_com. All rights reserved.


import UIKit
import Kingfisher

protocol EndlessLoopViewDelegate:class {
    func didSelectEndlessLoopViewIndex(index: IndexPath)
    func didScrollToIndex(index: Int)
}

class EndlessLoopView: UIView {
    
    var scrollView : UICollectionView!
    var scrollItemArr = [ScrollItem]()
    var primitiveResourceCount = 1
    let identifier = "cell"
    
    var self_width = CGFloat(0)
    var pageControl = UIPageControl()
    
    var pageCounter = UILabel()
    
    var timer:Timer?
    weak var endLessDelegate: EndlessLoopViewDelegate?
    
    enum PageType {
        case Label
        case Control
        case None
    }
    
    init(frame: CGRect,resourceArr:[ScrollItem],pageType: PageType, haveTimer: Bool = false) {
        super.init(frame: frame)
        
        
        if haveTimer && resourceArr.count > 1{
            addTimer()
        }
        
        self_width = frame.size.width
        primitiveResourceCount = resourceArr.count
        settingScrollView()
        settingPageControl()
        
        configData(resourceArr)
        
        addSubview(scrollView)
        
        switch pageType {
        case .Label:
            addSubview(pageCounter)
        case .Control:
            addSubview(pageControl)
        case .None:
            break
        }
        
    }
    
    func configData(_ resourceArr:[ScrollItem])
    {
        scrollItemArr = resourceArr
        if resourceArr.count != 1{
            scrollItemArr.insert(resourceArr.last!, at: 0)
            scrollItemArr.append(resourceArr.first!)
        }else{
            scrollView.bounces = false
            pageControl.isHidden = true
            pageCounter.isHidden = true
        }
        
    }
    
    func settingScrollView()
    {
        scrollView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: frame.size), collectionViewLayout: EndlessFlowLayout(frame: frame))
        
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.dataSource = self
        scrollView.contentSize.height = 0
        
        scrollView.register(EndlessLoopItem.classForCoder(), forCellWithReuseIdentifier: identifier)
        if primitiveResourceCount >= 2{
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width, y: 0), animated: false)
        }
    }
    
    func settingPageControl()
    {
        
        pageControl.pageIndicatorTintColor = .red
        let wid = CGFloat(60)
        let height = CGFloat(20)
        pageControl = UIPageControl(frame: CGRect(x: (bounds.width-wid)/2, y: (bounds.height-height*2), width: wid, height: height))
        pageControl.numberOfPages = primitiveResourceCount
        //        pageControl.backgroundColor = UIColor.blackColor()
        // 2184.72 + 1399.05
        // pageCounter ----------
        pageCounter.frame = pageControl.frame
        pageCounter.textAlignment = NSTextAlignment.center
        pageCounter.font = UIFont.systemFont(ofSize: 12)
        pageCounter.textColor = .white
        pageCounter.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        pageCounter.layer.cornerRadius = pageCounter.bounds.size.height/2
        pageCounter.layer.masksToBounds = true
        pageCounter.text = "1"
//        pageCounter.attributedText = labelString(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func labelString(_ us: Int)->NSMutableAttributedString
//    {
//        let sum = String(stringInterpolationSegment: primitiveResourceCount)
//        let cur = String(stringInterpolationSegment: us)
//
//        return ("\(cur) /" + "\(sum)").pageStringAttribute()
//    }
}

extension EndlessLoopView
{
    func addTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(setScrollViewContentOffSet), userInfo: nil, repeats: true)
    }
    
    func removeTimer()
    {
        guard let timer1 = self.timer else{ return }
        timer1.invalidate()
    }
    
    @objc func setScrollViewContentOffSet()
    {
        let currentOffsetPoint = scrollView.contentOffset
        let setPoint = CGPoint(x: currentOffsetPoint.x + bounds.size.width,y: 0)
        scrollView.setContentOffset(setPoint, animated: true)

    }
}

extension EndlessLoopView: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        endLessDelegate?.didSelectEndlessLoopViewIndex(index: indexPath)

    }
}
class EndlessFlowLayout: UICollectionViewFlowLayout{
    
    init(frame:CGRect) {
        super.init()
        
        //        itemSize = (collectionView?.frame.size)!
        //        itemSize = frame.size
        // 至此不知道为什么不能 itemSize = frame.size
        itemSize = CGSize(width: frame.size.width, height: frame.size.height*0.6)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollDirection = UICollectionViewScrollDirection.horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
extension EndlessLoopView: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return scrollItemArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! EndlessLoopItem
        cell.srollItem = scrollItemArr[indexPath.item]
        
        return cell
    }
    
}
extension EndlessLoopView: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        var targetX = scrollView.contentOffset.x
        let ArrCount = CGFloat(scrollItemArr.count)
        if ArrCount >= 3{
            if targetX >= frame.size.width * (ArrCount - 1){
                targetX = frame.size.width
                
                self.scrollView.setContentOffset(CGPoint(x: targetX, y: 0), animated: false)
            }else if targetX < 0{
                targetX = frame.size.width * (ArrCount - 2)
                self.scrollView.setContentOffset(CGPoint(x: targetX, y: 0), animated: false)
            }
            scrollView.contentSize.height = 0
        }
        var page = Int((scrollView.contentOffset.x+self_width*0.5) / self_width)
        page -= 1
        if page >= scrollItemArr.count{
            page = 0
        }
        if page < 0{
            page = scrollItemArr.count - 1
        }
        
        if page < abs(Int(ArrCount)-2){
            
            pageControl.currentPage = page
            
            pageCounter.text = "\(page + 1)"
//            pageCounter.attributedText = labelString(page+1)
        }

    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        removeTimer()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        addTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 && scrollView.contentOffset.x != scrollView.contentSize.width - scrollView.bounds.width{
            endLessDelegate?.didScrollToIndex(index: pageControl.currentPage)
        }
        
    }
}

class EndlessLoopItem: UICollectionViewCell
{
    var iconView = UIImageView()
    var srollItem = ScrollItem()
        {
        didSet{
            iconView = UIImageView()
            iconView.frame.size = bounds.size
            iconView.contentMode = .scaleAspectFill
            iconView.frame.origin = CGPoint(x: 0, y: 0)
            
            if let urlStr = srollItem.itemUrl{
//                if let url = NSURL(string: urlStr){
                
                    iconView.kf.setImage(with: urlStr, placeholder: srollItem.placeholderImage)
//                }
            }else if let name = srollItem.itemLocalName{
                iconView.image = UIImage(named: name)
            }
            
            contentView.addSubview(iconView)
        }
    }
    // 重用的时候把 imageView 移除
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.removeFromSuperview()
    }
    
    
}

extension String
{
    
//    func pageStringAttribute()->NSMutableAttributedString{
    
//        let rang = NSRange(location: 0, length: 2)
        
        
//        var attributeStr = [NSAttributedStringKey: AnyObject]()
//        attributeStr[NSAttributedStringKey.foregroundColor] = UIColor.white
//        attributeStr[NSAttributedStringKey.font] = UIFont(name:"Helvetica-Bold", size: 20)
    
//        let attStr = NSMutableAttributedString(string: self)
//
//        attStr.addAttribute(NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor),
//                            value: .white,
//                            range: rang)
//        if let font = UIFont(name: "Helvetica-Bold", size: 20){
//            attStr.addAttribute(NSAttributedStringKey.font,
//                                value: font,
//                                range: rang)
//        }
//        return attributeStr
//    }
    
    
}
/* 使用示例
 override func viewDidLoad() {
 super.viewDidLoad()
 
 let react = CGRect(x: 0, y: 100, width: 400, height: 220)
 let itemA = ScrollItem("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1512045523150&di=b75fe72a687612b6f1974da3ed1dbc6a&imgtype=0&src=http%3A%2F%2Fpic.jj20.com%2Fup%2Fallimg%2F1011%2F041GG44Q7%2F1F41G44Q7-2.jpg")
 let itemB = ScrollItem("https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3569457004,1571307316&fm=27&gp=0.jpg")
 let itemC = ScrollItem("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1512045552936&di=a76bdf9696386150e52a3378ecacc211&imgtype=0&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fcdbf6c81800a19d8ecf6e3eb39fa828ba71e4662.jpg")
 let items = [itemA,itemB,itemC]
 //        let items = [itemA]
 let endlessView = EndlessLoopView(frame: react, resourceArr: items, pageType: .None,haveTimer: true)
 view.addSubview(endlessView)
 endlessView.endLessDelegate = self
 showImage.kf.setImage(with: itemA.itemUrl)
 }
 
 extension ViewController: EndlessLoopViewDelegate{
 func didSelectEndlessLoopViewIndex(index: IndexPath) {
 print("index 当前选择的是 \(index)")
 }
 func didScrollToIndex(index: Int) {
 print("index 当前滚动到了 \(index)")
 }
 }

 */
