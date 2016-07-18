//
//  EndlessLoopView.swift
//  CollectionView轮播
//
//  Created by sunhua_com on 16/5/10.
//  Copyright © 2016年 sunhua_com. All rights reserved.
// 必须支持一种状态，那就是当是一张图片的时候，不滚动，就一张

import UIKit

class EndlessLoopView: UIView {
    
    var scrollView : UICollectionView!
    var scrollItemArr = [ScrollItem]()
    var primitiveResourceCount = 1
    let identifier = "cell"
    
    var self_width = CGFloat(0)
    var pageControl = UIPageControl()
    
    var pageCounter = UILabel()
    
    var timeInterval = 1
//    var timer = NSTimer(timeInterval: timeInterval, target: self(), selector: <#T##Selector#>, userInfo: nil, repeats: true)
    
    enum PageType {
        case Label
        case Control
        case None
    }
    
    init(frame: CGRect,resourceArr:[ScrollItem],pageType: PageType, haveTimer: Bool = false) {
        super.init(frame: frame)
        
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
        
        if haveTimer{
            
        }
    }
    
    func configData(resourceArr:[ScrollItem])
    {
        scrollItemArr = resourceArr
        if resourceArr.count != 1{
            scrollItemArr.insert(resourceArr.last!, atIndex: 0)
            scrollItemArr.append(resourceArr.first!)
        }else{
            scrollView.bounces = false
            pageControl.hidden = true
            pageCounter.hidden = true
        }
        
    }
    
    func settingScrollView()
    {
        scrollView = UICollectionView(frame: CGRect(origin: CGPointZero, size: frame.size), collectionViewLayout: EndlessFlowLayout(frame: frame))
        
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.dataSource = self
        scrollView.contentSize.height = 0
        
        scrollView.registerClass(EndlessLoopItem.classForCoder(), forCellWithReuseIdentifier: identifier)
        if primitiveResourceCount >= 2{
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width, y: 0), animated: false)
        }
    }
    
    func settingPageControl()
    {
        
        pageControl.pageIndicatorTintColor = UIColor.redColor()
        let wid = CGFloat(60)
        let height = CGFloat(20)
        pageControl = UIPageControl(frame: CGRect(x: (bounds.width-wid)/2, y: (bounds.height-height*2), width: wid, height: height))
        pageControl.numberOfPages = primitiveResourceCount
        //        pageControl.backgroundColor = UIColor.blackColor()
        
        // pageCounter ----------
        pageCounter.frame = pageControl.frame
        pageCounter.textAlignment = NSTextAlignment.Center
        pageCounter.font = UIFont.systemFontOfSize(12)
        pageCounter.textColor = UIColor.whiteColor()
        pageCounter.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        pageCounter.layer.cornerRadius = pageCounter.bounds.size.height/2
        pageCounter.layer.masksToBounds = true
        
        pageCounter.attributedText = labelString(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func labelString(us: Int)->NSMutableAttributedString
    {
        let sum = String(stringInterpolationSegment: primitiveResourceCount)
        let cur = String(stringInterpolationSegment: us)
        
        return ("\(cur) /" + "\(sum)").pageStringAttribute()
    }
}

extension EndlessLoopView
{
    func addTimer()
    {
        removeTimer()
        
//        timer = ns
    }
    
    func removeTimer()
    {
        
    }
}

extension EndlessLoopView: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        print(indexPath)
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
        scrollDirection = UICollectionViewScrollDirection.Horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
extension EndlessLoopView: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //        print("scrollItemArr.count\(scrollItemArr.count)")
        return scrollItemArr.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! EndlessLoopItem
        cell.srollItem = scrollItemArr[indexPath.item]
        cell.backgroundColor = UIColor.redColor()
        //        print(collectionView.contentInset)
        return cell
    }
    
}
extension EndlessLoopView: UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView)
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
            
            pageCounter.attributedText = labelString(page+1)
        }
        print("page->\(page)")
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        //        removeTimer()
        
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        //        addNSTimer()
        print("添加了定时器")
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
            iconView.contentMode = .ScaleAspectFill
            iconView.frame.origin = CGPoint(x: 0, y: 0)
            
            if let urlStr = srollItem.itemUrl{
                if let url = NSURL(string: urlStr){
                    iconView.kf_setImageWithURL(url, placeholderImage: srollItem.placeholderImage)
                }
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
    
    func pageStringAttribute()->NSMutableAttributedString{
        
        let rang = NSRange(location: 0, length: 2)
        
        let attStr = NSMutableAttributedString(string: self)
        
        attStr.addAttribute(NSForegroundColorAttributeName,
                            value: UIColor.whiteColor(),
                            range: rang)
        if let font = UIFont(name: "Helvetica-Bold", size: 20){
            attStr.addAttribute(NSFontAttributeName,
                                value: font,
                                range: rang)
        }
        return attStr
    }
    
    
}