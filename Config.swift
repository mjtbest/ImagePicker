//
//  Config.swift
//  ImagePicker
//
//  Created by mjt on 15/11/24.
//  Copyright © 2015年 mjt. All rights reserved.
//

import UIKit

// UIColor
let COLOR_BG = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)

//网络接口
var HTTP_BASE = "http://lecoinfrancais.org"
let HTTP_PHOTO_UPDATE = "\(HTTP_BASE)" + "/ami/picture_upload"
let HTTP_PHOTO_SAVE = "\(HTTP_BASE)" + "/ami/picture_save"
let HTTP_CONJUGAISON = "\(HTTP_BASE)" + "/dict/aconju"

//屏幕尺寸
let SCREEN_BOUNDS = UIScreen.mainScreen().bounds

//Text
let LoadMore = "上拉加载更多"
let LoadMorePull = "松开加载更多"
let LoadingMore = "加载中..."
let Update = "下拉刷新"
let UpdatePull = "松开刷新"
let Updating = "刷新中..."
let NoMore = "没有更多了"

//alertMessagge
let needLogin = "请登录后查看更多内容"