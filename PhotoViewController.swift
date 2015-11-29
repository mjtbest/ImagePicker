//
//  PhotoViewController.swift
//  ImagePicker
//
//  Created by mjt on 15/11/24.
//  Copyright © 2015年 mjt. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // userId
    var userId: String = "MaJT"
    // photo scroller view
    var scrollerViewPhoto : UIScrollView!
    var imgPicker: UIImagePickerController!
    var addCellImgView: UIImageView!
    var cellImgViewWidth: CGFloat!
    var cellImgViewHeight: CGFloat!
    let margin: CGFloat = 5                             // 图片的间距(上下左右)
    var photoNumOfRow: Int = 4                    // 每一行的图片数量
    var photoIndex:Int = 0                               // 图片总数索引值
    
    // MARK: - View DidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollerViewPhoto = UIScrollView()
        self.creatScrollerView(scrollerViewPhoto)
        self.initScrollerViewPhoto()
    }
    
    // MARK: - Photo ScrollerView
    
    // 创建照片视图
    func creatScrollerView(scrollerView: UIScrollView) {
        scrollerView.frame = self.view.frame
        scrollerView.backgroundColor = COLOR_BG
        scrollerView.alwaysBounceVertical = true
        self.view.addSubview(scrollerView)
    }
    
    // 初始化照片视图
    func initScrollerViewPhoto() {
        addCellImgView = UIImageView()
        
        cellImgViewWidth  = (self.view.bounds.width - margin * CGFloat(photoNumOfRow + 1)) / CGFloat(photoNumOfRow)
        cellImgViewHeight = cellImgViewWidth
        addCellImgView.frame = CGRectMake(margin, margin, cellImgViewWidth, cellImgViewHeight)
        addCellImgView.image = UIImage(named: "add_photo.png")
        addCellImgView.userInteractionEnabled = true
        addCellImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addPhoto"))
        self.scrollerViewPhoto.addSubview(addCellImgView)
        
        // 初始化UIImagePickerController
        imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
    }
    
    // 添加图片
    func addPhoto() {
        let alert = UIAlertController(title: "添加照片", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let photographAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { (_) -> Void in
            //判断是否获得相机
            if ((UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)) != nil) {
                self.imgPicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(self.imgPicker, animated: true, completion: nil)
            }
        }
        let albumAction = UIAlertAction(title: "从相册中选取", style: UIAlertActionStyle.Default) { (_) -> Void in
            //判断是否获得相册
            if ((UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.PhotoLibrary)) != nil) {
                self.imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(self.imgPicker, animated: true, completion: nil)
            }
        }
        let cancelAcrion = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(photographAction)
        alert.addAction(albumAction)
        alert.addAction(cancelAcrion)
        // 在iPad上alert是一个带箭头的,必须指明弹出位置
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = addCellImgView.frame
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - ImagePickerController Delegate
    
    // 成功打开相册
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        // 设置新图片的位置
//        let imgView = UIImageView()
//        imgView.frame = CGRectMake(margin + (margin + cellImgViewWidth) * CGFloat(photoIndex % photoNumOfRow), margin + (margin + cellImgViewHeight) * CGFloat(photoIndex / photoNumOfRow), cellImgViewWidth, cellImgViewHeight)
//        imgView.image = image
//        imgView.tag = photoIndex
//        imgView.userInteractionEnabled = true
//        // 自定义手势传值
//        let tap = CoustomTapGesture(target: self, action: "showBigPhoto:")
//        tap.imgView = imgView
//        imgView.addGestureRecognizer(tap)
//        self.scrollerViewPhoto.addSubview(imgView)
//        // 图片索引加一
//        photoIndex++
//        // 更新添加图标的位置
//        addCellImgView.frame = CGRectMake(margin + (margin + cellImgViewWidth) * CGFloat(photoIndex % photoNumOfRow), margin + (margin + cellImgViewHeight) * CGFloat(photoIndex / photoNumOfRow), cellImgViewWidth, cellImgViewHeight)
//    }
    
    // 和上面的方法实现一样, 只能二选一
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        /** 此处info 有六个值
        * UIImagePickerControllerMediaType        // an NSString UTTypeImage)
        * UIImagePickerControllerOriginalImage   // a UIImage 原始图片
        * UIImagePickerControllerEditedImage     // a UIImage 裁剪后图片
        * UIImagePickerControllerCropRect           // an NSValue (CGRect)
        * UIImagePickerControllerMediaURL         // an NSURL
        * UIImagePickerControllerReferenceURL  // an NSURL that references an asset in the AssetsLibrary framework
        * UIImagePickerControllerMediaMetadata // an NSDictionary containing metadata from a captured photo
        */
        let dic = info as NSDictionary
        // 编辑过后的图片
        let editedImage = dic.objectForKey("UIImagePickerControllerEditedImage") as? UIImage

        // 设置新图片的位置
        let imgView = UIImageView()
        imgView.frame = CGRectMake(margin + (margin + cellImgViewWidth) * CGFloat(photoIndex % photoNumOfRow), margin + (margin + cellImgViewHeight) * CGFloat(photoIndex / photoNumOfRow), cellImgViewWidth, cellImgViewHeight)
        // 将裁减后的照片传给imageView
        let scaledWidth: CGFloat = (editedImage?.size.width > 800) ? 800 : (editedImage?.size.width)!
        let scaledHeight: CGFloat = scaledWidth * (editedImage!.size.height / editedImage!.size.width)
        let scaledImg = self.scaleFromImage(editedImage!, size: CGSize(width: scaledWidth, height: scaledHeight))
        imgView.image = scaledImg
        imgView.tag = photoIndex
        imgView.userInteractionEnabled = true

        // 自定义手势传值
        let tap = CoustomTapGesture(target: self, action: "showBigPhoto:")
        tap.imgView = imgView
        imgView.addGestureRecognizer(tap)
        self.scrollerViewPhoto.addSubview(imgView)
        // 图片索引加一
        photoIndex++
        // 更新添加图标的位置
        addCellImgView.frame = CGRectMake(margin + (margin + cellImgViewWidth) * CGFloat(photoIndex % photoNumOfRow), margin + (margin + cellImgViewHeight) * CGFloat(photoIndex / photoNumOfRow), cellImgViewWidth, cellImgViewHeight)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Image Scaling
    
    // 图片全屏的点击事件
    func showBigPhoto(sender: CoustomTapGesture) {
        let orignImgView = sender.imgView
        let fullScreenView = UIImageView()
        let maskView = UIView()
        
        maskView.backgroundColor = UIColor.blackColor()
        fullScreenView.image = orignImgView?.image
        maskView.addSubview(fullScreenView)
        
        // 只有添加到self.view上才能实现全屏
        self.view.addSubview(maskView)
        // 实现自定义动画
        fullScreenView.userInteractionEnabled = true
        let tap = CoustomTapGesture(target: self, action: "recoveryPhoto:")
        tap.oldImgView = orignImgView
        tap.imgView = fullScreenView
        tap.maskView = maskView
        fullScreenView.addGestureRecognizer(tap)
        // 全屏显示动画
        maskView.frame = orignImgView!.frame
        maskView.alpha = 0
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            maskView.frame = self.view.frame
            maskView.alpha = 1
            let imgW: CGFloat = maskView.bounds.width
            let imgH: CGFloat = imgW * orignImgView!.frame.height / orignImgView!.frame.width
            fullScreenView.frame = CGRectMake(0, (maskView.bounds.height - imgH) / 2, imgW, imgH)
            self.view.bringSubviewToFront(maskView)
        })
    }
    
    // 图片恢复原始位置的点击事件
    func recoveryPhoto(sender: CoustomTapGesture) {
        let imgView = sender.oldImgView
        let fullScreenView = sender.imgView
        let maskView = sender.maskView
        // 必须添加到原始的View上才能恢复原始位置
        self.scrollerViewPhoto.addSubview(fullScreenView!)
        // 实现自定义手势
        let tap = CoustomTapGesture(target: self, action: "showBigPhoto:")
        tap.oldImgView = fullScreenView
        tap.imgView = imgView
        fullScreenView!.addGestureRecognizer(tap)
        // 图片恢复动画
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            maskView?.removeFromSuperview()
            fullScreenView!.frame = imgView!.frame
        })
    }
    
    // 裁剪图片尺寸
    func scaleFromImage(image:UIImage, size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
