//
//  ViewController.swift
//  SlideshowApp
//
//  Created by apple on 2020/02/10.
//  Copyright © 2020 yo.sato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //画像ファイル名リスト
    let imageList: [String] = ["KIMG0130",
                               "KIMG0131",
                               "KIMG0132",
                               "KIMG0133",
                               "KIMG0135",
                               "KIMG0137",
                               "KIMG0138",
                               "KIMG0139",
                               "KIMG0141",
                               "KIMG0142",
                               "KIMG0143",
                               "KIMG0144"]
            
    //次へボタン
    @IBOutlet weak var nextButton: UIButton!
    
    //戻るボタン
    @IBOutlet weak var backButton: UIButton!
    
    //再生・停止ボタン
    @IBOutlet weak var autoButton: UIButton!
    
    //イメージビュー
    @IBOutlet weak var imageView: UIImageView!
    
    //スライドビュー中のフラグ
    var autoFlg = false
    
    //タイマー
    var timer: Timer!
    
    //現在表示している画像の番号
    var curImageIndex: Int = 0
    
    //イメージビューの初期表示状態を格納
    var initImageViewOrigin: CGPoint!

    //初期処理
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //イメージビューの初期表示状態を保持
        initImageViewOrigin = imageView.frame.origin;
        
        //最初の画像を表示
        displayImage(Index : curImageIndex)
        
    }

    //画像を表示
    @objc func displayImage(Index index: Int) {
        
        //画像ファイルを取得
        let img = UIImage(named:imageList[index])!
        
        // 画像の縦横サイズを取得
        let imgWidth:CGFloat = img.size.width
        let imgHeight:CGFloat = img.size.height
        
        // イメージビューの横サイズを取得
        let imageViewWidth:CGFloat = imageView.frame.size.width
                
        // 画像サイズをイメージビュー幅に合わせる
        let scale:CGFloat = imageViewWidth / imgWidth

        // リサイズ処理
        let reSizeImg = ViewController.reSizeImage(image: img,reSize: CGSize(width: imgWidth * scale, height: imgHeight * scale))
                
        // 画像をイメージビューに設定
        let curImageView = UIImageView(image: reSizeImg)
        imageView.addSubview(curImageView)
        
    }

    // 画像のリサイズを行う
    static func reSizeImage(image :UIImage ,reSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        image.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }

    // スライドビューモードの時、定期的に実行
    @objc func updateTimer(_ timer: Timer) {
        
        if (autoFlg == true){
            //次の画像へ
            btnNext(nil)
        }
                
    }

    //次へボタンを押下
    @IBAction func btnNext(_ sender: Any!) {
        
        //番号を進めて画像を表示
        if (curImageIndex < imageList.count - 1)
        {
            curImageIndex += 1
        }
        else
        {
            curImageIndex = 0
        }
        displayImage(Index : curImageIndex)
                
    }

    //戻るボタンを押下
    @IBAction func btnBack(_ sender: Any!) {
        
        //番号を戻して画像を表示
        if (curImageIndex > 0)
        {
            curImageIndex -= 1;
        }
        else
        {
            curImageIndex = imageList.count - 1
        }
        displayImage(Index : curImageIndex)
                
    }
    
    //再生・停止ボタンを押下
    @IBAction func btnAuto(_ sender: Any!) {
        
        if autoFlg == false {
            
            //停止中の場合、スライドショーを開始する
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self,
                        selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
            
            nextButton.isEnabled = false
            backButton.isEnabled = false
            autoButton.setTitle("停止", for: .normal)
            autoFlg = true
            
        }
        else
        {
         
            //再生中の場合、スライドショーを停止する
            self.timer.invalidate()
                        
            nextButton.isEnabled = true
            backButton.isEnabled = true
            autoButton.setTitle("再生", for: .normal)
            autoFlg = false
            
        }
                
    }
    
    //遷移時の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segueから遷移先のViewControllerを取得する
        let resultViewController:NextViewController = segue.destination as! NextViewController

        //遷移先の画像を設定する
        let img = UIImage(named:imageList[curImageIndex])!
        resultViewController.initImage = img
        
        if autoFlg == true {
            //スライドショーを停止する
            timer.invalidate()
        }
        
    }
    
    //遷移先から戻った時の処理
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
                
        if autoFlg == true {
            //スライドショーを再開する
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self,
                        selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
        }
        
    }
    
}

