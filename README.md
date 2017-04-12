# CycleScrollView

* An easy way to intergrate Advertising carousel!

# Contents

* Gettting Started!
1. need to intergrate Kingfinsher to support it! [Kingfisher](https://github.com/onevcat/Kingfisher)
2. inherit from UIView, a lightWeight frameWork.
3. it supports UIPageControl and Text to show current index.
4. it has three positions(left , middle ,right) of the indicator.
5. the UI elements of CycleView is customizable.

* Comment API
1. [CycleScrollView.swift](https://github.com/pengfan123/CycleScrollView/blob/master/CycleScrollView/CycleScrollView.swift)
2. [CycleInfoLabel.swift](https://github.com/pengfan123/CycleScrollView/blob/master/CycleScrollView/CycleInfoLabel.swift)

* Requirements
1. iOS 8.0+
2. Swift 3
3. need to intergrate Kingfinsher

# How to use?
 <br>`let dataArr = ["http://1.jpg", "http://2.jpg", "http://3.jpg"]`
 <br>`let cycleScrollView = CycleScrollView.init(frame: CGRect.init(x: 0, y: 100, width: self.view.bounds.size.width, height: 200), data: dataArr)`
 <br>`cycleScrollView.delegate = self`
 <br> `view.addSubview(cycleScrollView)`
