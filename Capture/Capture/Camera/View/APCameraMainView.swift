//
//  APCameraMainView.swift
//  Capture
//
//  Created by dulingkang on 8/11/15.
//  Copyright © 2015 ShawnDu. All rights reserved.
//

import UIKit

protocol APCameraMainViewDelegate {
    func takePhoto()
    func browsePhoto(array: NSArray)
    func closeMainView()
}

class APCameraMainView: UIView {
    
    var preView: UIView!
    var topView: UIView!
    var filterView: APCameraFilterCollectionView?
    var bottomView: UIView!
    var albumButton: UIButton!
    var previewImageView: UIImageView?
    var photoNumber: Int?
    var numberLabel: UILabel?
    var tmpPhotoArray: [UIImage] = []
    var apCameraMainViewDelegate: APCameraMainViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    //MARK: - event response
    func topButtonPressed(button: UIButton) {
        
    }
    
    func browsePhoto() {
        self.apCameraMainViewDelegate?.browsePhoto(self.tmpPhotoArray)
    }
    
    func triggerButtonPressed(sender: UIButton) {
        self.apCameraMainViewDelegate?.takePhoto()
    }
    
    func closeButtonPressed(sender: UIButton) {
        self.apCameraMainViewDelegate?.closeMainView()
    }
    
    //MARK: - public method
    func addPreviewImageView() {
        if self.previewImageView == nil {
            self.previewImageView = UIImageView.init(frame: self.albumButton.frame)
            self.previewImageView?.contentScaleFactor = UIScreen.mainScreen().scale
            self.previewImageView?.contentMode = UIViewContentMode.ScaleAspectFill
            self.previewImageView?.autoresizingMask = UIViewAutoresizing.FlexibleHeight
            self.previewImageView?.clipsToBounds = true
            self.previewImageView?.userInteractionEnabled = true
            self.bottomView.addSubview(self.previewImageView!)
            let tap = UITapGestureRecognizer.init(target: self, action: "toPhotoBrowse")
            self.previewImageView?.addGestureRecognizer(tap)
            self.photoNumber = 0
        }
    }
    
    func addNumberLabel() {
        if self.numberLabel == nil {
            self.numberLabel = UILabel.init(frame: CGRectMake(0, 0, 28, 16))
            self.numberLabel?.center = CGPointMake(self.previewImageView!.right, self.previewImageView!.top)
            self.numberLabel?.backgroundColor = kRGBA(0.918, g: 0.333, b: 0.329, a: 1.0)
            self.numberLabel?.layer.cornerRadius = 8
            self.numberLabel?.layer.masksToBounds = true
            self.numberLabel?.textColor = UIColor.whiteColor()
            self.numberLabel?.textAlignment = NSTextAlignment.Center
            self.bottomView.addSubview(self.numberLabel!)
        }
        self.photoNumber = self.photoNumber! + 1
        self.numberLabel?.text = String(format: "%d", self.photoNumber!)
    }
    
    func setImageForPreviewImageView(image: UIImage) {
        self.tmpPhotoArray.append(image)
        self.uploadPreviewImageView(image)
    }
    
    func reloadPreviewImageView(photoArray: NSMutableArray) {
        if photoArray.count == 0 {
            self.previewImageView?.hidden = true
            self.albumButton.hidden = false
            self.numberLabel?.hidden = true
            self.photoNumber = 1
        } else {
            self.uploadPreviewImageView(photoArray[photoArray.count-1] as! UIImage)
            self.numberLabel?.text = String(format: "%d", photoArray.count)
            self.photoNumber = photoArray.count + 1
        }
    }
    
    func uploadPreviewImageView(image: UIImage) {
        self.previewImageView?.hidden = false
        self.numberLabel?.hidden = false
        self.previewImageView?.image = image
        let lastCenter = self.previewImageView?.center
        self.previewImageView?.frame = CGRectMake(kScreenWidth/8, kCameraBottomHeight/2 , 0,0)
        self.previewImageView?.center = lastCenter!
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.6, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.previewImageView?.frame = CGRectMake(kScreenWidth/8, (kCameraBottomHeight - kButtonClickWidth)/2 , kButtonClickWidth, kButtonClickWidth)
            }, completion: {
                finished in
        })
    }
    
    //MARK: - private method
    func initViews() {
        self.backgroundColor = kRGBA(0.447, g: 0.894, b: 0.973, a: 1.0)
        self.addPreView()
        self.addTopView()
        self.addSliderView()
        self.addFilterView()
        self.addBottomView()
    }
    
    func addPreView() {
        self.preView = UIView.init(frame: CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenWidth*4/3))
        self.addSubview(self.preView)
    }
    
    func addTopView() {
        self.topView = UIView.init(frame: CGRectMake(0, 0, kScreenWidth, kNavigationHeight))
        self.topView.backgroundColor = UIColor.blackColor()
        self.addSubview(self.topView)
        self.addTopButtons()
    }
    
    func addSliderView() {
        
    }
    
    func addFilterView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.filterView = APCameraFilterCollectionView.init(frame: CGRectMake(0, kScreenHeight - kCameraBottomHeight - kCameraFilterHeight, kScreenWidth, kCameraFilterHeight), collectionViewLayout: layout)
        self.addSubview(self.filterView!)
    }
    
    func addBottomView() {
        if (self.bottomView == nil) {
            self.bottomView = UIView.init(frame: CGRectMake(0, kScreenHeight - kCameraBottomHeight, kScreenWidth, kCameraBottomHeight))
        }
        self.bottomView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.bottomView)
        self.addAlbumButton()
        self.addTriggerButton()
        self.addCloseButton()
    }
    
    func addTopButtons() {
        let normalNameArray = ["xiaoka_ratio_normal_01", "xiaoka_black_normal", "timer_normal", "flash_normal", "switchNormal"]
        let pressNameArray = ["xiaoka_ratio_press_01", "xiaoka_black_press", "timer_press", "flash_press", "switchPress"]
        for index in 0...normalNameArray.count-1 {
            let floatIndex: CGFloat = CGFloat(index)
            let button = UIButton.init(frame: CGRectMake(kScreenWidth*floatIndex/5, 0, kScreenWidth/5, kNavigationHeight))
            button.tag = kCameraViewTopButtonStartTag + index
            let imageNomal = normalNameArray[index]
            let imagePress = pressNameArray[index]
            button.setImage(UIImage(named: imageNomal), forState: UIControlState.Normal)
            button.setImage(UIImage(named: imagePress), forState: UIControlState.Selected)
            button.addTarget(self, action: "topButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            self.topView.addSubview(button)
        }
    }
    
    func addAlbumButton() {
        self.albumButton = UIButton.init(frame: CGRectMake(kScreenWidth/8, (kCameraBottomHeight - kButtonClickWidth)/2, kButtonClickWidth, kButtonClickWidth))
        self.albumButton.backgroundColor = UIColor.clearColor()
        self.albumButton.setImage(UIImage(named: "cameraAlbumNormal"), forState: UIControlState.Normal)
        self.albumButton.setImage(UIImage(named: "cameraAlbumPress"), forState: UIControlState.Selected)
        self.albumButton.addTarget(self, action: "browsePhoto", forControlEvents: UIControlEvents.TouchUpInside)
        self.bottomView.addSubview(self.albumButton)
    }
    
    func addTriggerButton() {
        let triggerNormalImage = UIImage(named: "cameraTriggerNormal")
        let triggerButton = UIButton.init(frame: CGRectMake((kScreenWidth - (triggerNormalImage?.size.width)!)/2, (kCameraBottomHeight - (triggerNormalImage?.size.height)!)/2, (triggerNormalImage?.size.width)!, (triggerNormalImage?.size.height)!))
        triggerButton.backgroundColor = UIColor.clearColor()
        triggerButton.setImage(triggerNormalImage, forState: UIControlState.Normal)
        triggerButton.setImage(UIImage(named: "cameraTriggerPress"), forState: UIControlState.Selected)
        triggerButton.addTarget(self, action: "triggerButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.bottomView.addSubview(triggerButton)
    }
    
    func addCloseButton() {
        let closeButton = UIButton.init(frame: CGRectMake(kScreenWidth*7/8 - kButtonClickWidth, (kCameraBottomHeight - kButtonClickWidth)/2, kButtonClickWidth, kButtonClickWidth))
        closeButton.backgroundColor = UIColor.clearColor()
        closeButton.setImage(UIImage(named: "cameraCloseNormal"), forState: UIControlState.Normal)
        closeButton.setImage(UIImage(named: "cameraClosePress"), forState: UIControlState.Selected)
        closeButton.addTarget(self, action: "closeButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.bottomView.addSubview(closeButton)
    }
    
}












