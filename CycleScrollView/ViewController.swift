//
//  ViewController.swift
//  CycleScrollView
//
//  Created by 软件开发部2 on 2017/4/5.
//  Copyright © 2017年 软件开发部2. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CycleScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let dataArr = ["https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1491959993&di=a935350ec4ca9b7443a50696833ae365&src=http://5.26923.com/download/pic/000/326/dfb574d0670fca0713fe3a4b3c6b7613.jpg", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1491970078708&di=cc175f8fc653b50b3c05dbb40132e14a&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fw3%2F95%2Fd%2F105.jpg", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1491970078708&di=78804d49362348c57fbbabe0e3d61bf7&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fpic%2Fitem%2F2fb965605ec3d77594ca6b94.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1491970078706&di=04a7ecffe7f122ebbec814890652108f&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fb90e7bec54e736d1e1a5088499504fc2d462698c.jpg", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1491970078704&di=8cb7c55ccec8a3928ce3e29128824fbb&imgtype=0&src=http%3A%2F%2Fa-ssl.duitang.com%2Fuploads%2Fblog%2F201406%2F01%2F20140601192329_efL8U.jpeg"]
        let cycleScrollView = CycleScrollView.init(frame: CGRect.init(x: 0, y: 100, width: self.view.bounds.size.width, height: 200), data: dataArr)
        cycleScrollView.delegate = self
        cycleScrollView.indicateStyle = .textStyle
        cycleScrollView.indicatePositon = .center
        view.addSubview(cycleScrollView)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let two = TwoController.init()
//        self.present(two, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: CycleScrollViewDelegate
    func CycleScrollViewDidClick(index: Int) {
         print("click  \(index)")
    }
    func CycleScrollViewDidScroll(index: Int) {
        print("scroll to \(index)")
    }

}

