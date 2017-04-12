//
//  CycleScrollView.swift
//  CycleScrollView
//
//  Created by 软件开发部2 on 2017/4/10.
//  Copyright © 2017年 软件开发部2. All rights reserved.
//

import UIKit
import Kingfisher
protocol CycleScrollViewDelegate {
    func CycleScrollViewDidScroll(index: Int)
    func CycleScrollViewDidClick(index: Int)
}

class CycleScrollView: UIView , UIScrollViewDelegate{
    
    enum diotStyle{//指示点的样式
        case pageControlStyle, textStyle
    }
    enum diotPosition{//指示点的位置
        case left, center, right
    }
    
    //MARK: property
    let TAG_OFFSET = 1000
    var currentPageIndicatorTintColor: UIColor = .orange{
        didSet{
            pageControl?.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
        
    }
    var pageIndicatorTintColor: UIColor = .white{
        didSet{
            pageControl?.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }
    var timer: Timer?
    var currentIndex: Int = 0
    var indicateStyle :diotStyle = .pageControlStyle{
        didSet{
            if oldValue != indicateStyle {
               pageControl?.isHidden = (indicateStyle != .pageControlStyle)
               infoLabel?.isHidden = (indicateStyle == .pageControlStyle)
            }
        }
    }
    var indicatePositon :diotPosition = .left{
        didSet{
            if  oldValue != indicatePositon {
                switch indicatePositon {
                case .right:
                    pageControl?.frame.origin.x = self.bounds.size.width * 0.85 - (pageControl?.frame.width)!
                    infoLabel?.frame.origin.x = (pageControl?.frame.origin.x)!
                    break
                case .left:
                    pageControl?.frame.origin.x = self.bounds.size.width * 0.15
                     infoLabel?.frame.origin.x = (pageControl?.frame.origin.x)!
                    break
                case .center:
                    pageControl?.center.x = self.bounds.size.width * 0.5
                    infoLabel?.center.x = (pageControl?.center.x)!
                    break
                }
            }
        }
    }
    var indicateColor: UIColor = .white
    var placeHolderImage: UIImage?
    var textColor: UIColor = .black{
        didSet
        {
            infoLabel?.textColor = textColor
        }
    
    }
    var textFont: UIFont = UIFont.systemFont(ofSize: 20){
        didSet
        {
            infoLabel?.font = textFont
        }
        
    }
    var shouldAnimate: Bool = true
    var animateDuration :TimeInterval = 4.0
    var pageControl: UIPageControl?
    var infoLabel: CycleInfoLabel?
    var mainScroll: UIScrollView?
    var delegate: CycleScrollViewDelegate?
    var dataArr: [String] = []{//适配更新DataArr的情况
        didSet{
            deconstructTimer()
            refreshUI()//刷新UI
            callTimer()
        }
    }
    private var leftImageView: UIImageView?
    private var middleImageView: UIImageView?
    private var rightImageView: UIImageView?
    
    //MARK: life cycle
    convenience init(frame: CGRect, data: [String]){
        self.init(frame: frame)
        self.setupUI()
        dataArr = data
        pageControl?.numberOfPages = dataArr.count
        infoLabel?.totalCount = dataArr.count
        deconstructTimer()
        refreshUI()//刷新UI
        callTimer()
    }
    
    //MARK: private method
    private func setupUI(){
        mainScroll = UIScrollView.init(frame: bounds)
        mainScroll?.isPagingEnabled = true
        mainScroll?.showsHorizontalScrollIndicator = false
        mainScroll?.showsVerticalScrollIndicator = false
        mainScroll?.bounces = false
        addSubview(mainScroll!)
        mainScroll?.delegate = self
        
        leftImageView = initImageView(frame: CGRect.init(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height), tag: TAG_OFFSET)
        
        middleImageView = initImageView(frame: CGRect.init(x: bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height), tag: TAG_OFFSET + 1)
        
        rightImageView = initImageView(frame: CGRect.init(x: bounds.size.width * 2, y: 0, width: bounds.size.width, height: bounds.size.height), tag: TAG_OFFSET + 2)
        
        
        pageControl = UIPageControl.init(frame: CGRect.init(x: bounds.size.width * 0.15, y: bounds.size.height * 0.85, width: 0, height: 0))
        addSubview(pageControl!)
        pageControl?.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl?.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        pageControl?.currentPage = currentIndex
        pageControl?.numberOfPages = 0
        
        infoLabel = CycleInfoLabel.init(frame: CGRect.init(x: bounds.size.width * 0.15, y: bounds.size.height * 0.85, width: 100, height: 20), currentIndex: 0, totalCount: 0)
        addSubview(infoLabel!)
        infoLabel?.isHidden = true
    }
    
    //refresh
    private func refreshUI(){
        currentIndex = 0
        pageControl?.currentPage = currentIndex
        pageControl?.numberOfPages = dataArr.count
        infoLabel?.currentIndex = currentIndex
        infoLabel?.totalCount = dataArr.count
        pageControl?.isHidden = (dataArr.count == 0)
        if dataArr.count == 0 || dataArr.count == 1
        {
            mainScroll?.contentSize = CGSize.init(width: 0, height: 0)
            mainScroll?.contentOffset = CGPoint.init(x: 0, y: 0)
            if dataArr.count == 0
            {
                leftImageView?.image = placeHolderImage
            }
            else
            {
                setImageURL(imageURL: dataArr[0], imageView: leftImageView)
            }
            
        }
        else
        {
            mainScroll?.contentSize = CGSize.init(width: bounds.size.width * 3, height: 0)
            mainScroll?.contentOffset = CGPoint.init(x: bounds.size.width, y: 0)
            setImage()
        }

    }
    //初始化三个imageView
    private func initImageView(frame: CGRect, tag: Int) -> UIImageView{
        let imageView = UIImageView.init(frame: frame)
        imageView.tag = tag
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleGesture(gesture:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(recognizer)
        mainScroll?.addSubview(imageView)
        return imageView
    }
    
    //创建timer
    private func callTimer(){
        if dataArr.count < 2 { //图片数量少于2张时不创建定时器
            return
        }
        if timer == nil || timer?.isValid == false { //只要timer为nil或者timer无效时才创建
            DispatchQueue.global().async {
                [unowned self] in
                self.timer = Timer.init(timeInterval: self.animateDuration, target: self, selector: #selector(self.updateImage), userInfo: nil, repeats: true)
                RunLoop.current.add(self.timer!, forMode: .commonModes)
                RunLoop.current.run()
            }
            
        }
    }
    
    private func deconstructTimer(){
        if  timer?.isValid == true
        {
            timer?.invalidate()
            timer = nil
        }
    }
    
   @objc private func updateImage(){
    if shouldAnimate == false {
        return
    }
    mainScroll?.setContentOffset(CGPoint.init(x: bounds.size.width * 2, y: 0), animated: true)
    Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(scrollViewDidEndDecelerating(_:)), userInfo: nil, repeats: false)//定时器调用这个之后,要调用一下scrollViewDidEndDecelerating方法刷新
    
    }
    @objc private func handleGesture(gesture: UIGestureRecognizer){
        delegate?.CycleScrollViewDidClick(index: currentIndex)
        
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        shouldAnimate = false
        deconstructTimer()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if  mainScroll?.contentOffset.x  == mainScroll?.frame.size.width{ //没有滑动
            return
        }
        else
        {
        if mainScroll?.contentOffset.x == 0 {//左滑
            currentIndex  = (currentIndex - 1 + dataArr.count) % dataArr.count
        }
        else //右滑
        {
            currentIndex  = (currentIndex + 1) % dataArr.count
            
        }
            setImage()
            updateDisplayInfo()
        }
        mainScroll?.contentOffset = CGPoint.init(x: bounds.size.width, y: 0)
        if  shouldAnimate == false {
            shouldAnimate = true
            callTimer()
        }
        delegate?.CycleScrollViewDidScroll(index: currentIndex)
    }
    
    //set image
    private func setImage(){
        var leftIndex = 0
        let middleIndex = currentIndex
        var rightIndex = 0
        if dataArr.count == 2 {
           leftIndex = (currentIndex - 1 + 2) % 2
           rightIndex = leftIndex
        }
        else if dataArr.count > 2
        {
            leftIndex = (currentIndex - 1 + dataArr.count) % dataArr.count
            rightIndex = (currentIndex + 1) % dataArr.count
        }
        setImageURL(imageURL: dataArr[leftIndex], imageView: leftImageView)
        setImageURL(imageURL: dataArr[middleIndex], imageView: middleImageView)
        setImageURL(imageURL: dataArr[rightIndex], imageView: rightImageView)
        
    }
    private func setImageURL(imageURL: String, imageView: UIImageView?){
        if let url = URL.init(string: imageURL)
        {
            let imageResource = ImageResource.init(downloadURL: url)
            imageView?.kf.setImage(with: imageResource, placeholder: placeHolderImage, options: nil, progressBlock: nil, completionHandler: nil)
        }
        else
        {
            imageView?.image = placeHolderImage
        }

    }
    //更新显示信息,例如pageControl,或者是显示当前页面的文本信息
    private func updateDisplayInfo(){
        pageControl?.currentPage = currentIndex
        infoLabel?.currentIndex = currentIndex + 1
        
    }

}
