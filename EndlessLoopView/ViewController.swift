//
//  ViewController.swift
//  EndlessLoopView
//
//  Created by apple on 2017/12/1.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let react = CGRect(x: 0, y: 100, width: 400, height: 220)
        let itemA = ScrollItem("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1512045523150&di=b75fe72a687612b6f1974da3ed1dbc6a&imgtype=0&src=http%3A%2F%2Fpic.jj20.com%2Fup%2Fallimg%2F1011%2F041GG44Q7%2F1F41G44Q7-2.jpg")
        let itemB = ScrollItem("https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3569457004,1571307316&fm=27&gp=0.jpg")
        let itemC = ScrollItem("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1512045552936&di=a76bdf9696386150e52a3378ecacc211&imgtype=0&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fcdbf6c81800a19d8ecf6e3eb39fa828ba71e4662.jpg")
        let items = [itemA,itemB,itemC]
        //        let items = [itemA]
        let endlessView = EndlessLoopView(frame: react, resourceArr: items, pageType: .Control,haveTimer: true)
        view.addSubview(endlessView)
        endlessView.endLessDelegate = self
        
    }
    
}
extension ViewController: EndlessLoopViewDelegate{
    func didSelectEndlessLoopViewIndex(index: IndexPath) {
        print("index 当前选择的是 \(index)")
    }
    func didScrollToIndex(index: Int) {
        print("index 当前滚动到了 \(index)")
    }
}



