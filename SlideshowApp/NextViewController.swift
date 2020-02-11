//
//  NextViewController.swift
//  SlideshowApp
//
//  Created by apple on 2020/02/11.
//  Copyright © 2020 yo.sato. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    
    //前画面から受け取る画像
    var initImage : UIImage!
    
    //イメージビュー
    @IBOutlet weak var imageView: UIImageView!

    //初期処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // スクリーンの横サイズを取得
        let imageViewWidth:CGFloat = view.frame.size.width
                
        // 画像の縦横サイズを取得
        let imgWidth:CGFloat = initImage.size.width
        let imgHeight:CGFloat = initImage.size.height
        
        // 画像サイズをスクリーン幅に合わせる
        let scale:CGFloat = imageViewWidth / imgWidth

        // リサイズ処理
        let reSizeImg =
            ViewController.reSizeImage(image: initImage,
                                       reSize: CGSize(width: imgWidth * scale, height: imgHeight * scale))

        //イメージビューに画像を設定
        let curImageView = UIImageView(image: reSizeImg)
        imageView.addSubview(curImageView)

    }
    
}
