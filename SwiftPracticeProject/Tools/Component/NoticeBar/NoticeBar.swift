//
//  NoticeBar.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/6.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit
fileprivate let _statusBarHeight = UIApplication.shared.statusBarFrame.height

enum NoticeBarAnimationType {
    case top
    case bottom
    case left
    case right
}
extension NoticeBarAnimationType {
    fileprivate func noticeBarViewTransform(with frame: CGRect, _ style: NoticeBarStyle) -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        switch self {
        case .top, .bottom:
            transform = CGAffineTransform(translationX: 0, y: -frame.height)
        case .left:
            transform = CGAffineTransform(translationX: -frame.width, y: 0)
        case .right:
            transform = CGAffineTransform(translationX: frame.width, y: 0)
        }
        
        return transform
        
    }
}

enum NoticeBarStyle {
    case statusBar
    case navgationBar
}
fileprivate struct NoticeBarProperties {
    var shadowOffsetY: CGFloat = 0
    var fontSizeScaleFactor: CGFloat = 0
    var textFont = UIFont()
    var viewFrame = CGRect.zero
    
    init(shadowOffsetY: CGFloat, fontSizeScaleFactor: CGFloat, textFont: UIFont, viewFrame: CGRect) {
        self.shadowOffsetY = shadowOffsetY
        self.fontSizeScaleFactor = fontSizeScaleFactor
        self.textFont = textFont
        self.viewFrame = viewFrame
    }
    
    
    
}
extension NoticeBarStyle {
   

    fileprivate func noticeBarProperties() -> NoticeBarProperties{
        let screenWidth = UIScreen.main.bounds.width
        var properties: NoticeBarProperties
        switch self {
        case .navgationBar:
            properties = NoticeBarProperties(shadowOffsetY: 3, fontSizeScaleFactor: 0.55, textFont: UIFont.systemFont(ofSize: 18), viewFrame: CGRect(origin: CGPoint.zero, size: CGSize(width: screenWidth, height: 44 + _statusBarHeight)))
        case .statusBar:
            properties = NoticeBarProperties(shadowOffsetY: 2, fontSizeScaleFactor: 0.75, textFont: UIFont.systemFont(ofSize: 13), viewFrame: CGRect(origin: CGPoint.zero, size: CGSize(width: screenWidth, height: _statusBarHeight)))
        }
        
        return properties
    }
    
    fileprivate func noticeBarOriginY(superViewHeight: CGFloat, _ height: CGFloat) -> CGFloat {
        var originY: CGFloat = 0
        switch self {
        case .navgationBar:
            originY = _statusBarHeight + (superViewHeight - _statusBarHeight - height) * 0.5
        case .statusBar:
            originY = (superViewHeight - height) * 0.5
        }
        return originY
    }
    
    fileprivate var beginWindowLevel: UIWindow.Level {
        switch self {
        case .statusBar:
            return .statusBar + 1
        default: return .normal
        }
    }
    
    fileprivate var endWindowLevel: UIWindow.Level {.normal}
}

struct NoticeBarConfig {
    var title = ""
    var image: UIImage?
    var margin: CGFloat = 10.0
    var textColor = UIColor.black
    var backgroundColor = UIColor.white
    var animationType = NoticeBarAnimationType.top
    var barStyle = NoticeBarStyle.navgationBar
    
    init(title: String = "", image: UIImage? = nil, textColor: UIColor = UIColor.white, backgroundColor: UIColor = UIColor.orange, barStyle: NoticeBarStyle = .navgationBar,
         animationType: NoticeBarAnimationType = .top) {
        self.title = title
        self.image = image
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.barStyle =  barStyle
        self.animationType = animationType
    }
    
    
    
    
}

class NoticeBar: UIView {
    private var config = NoticeBarConfig()
    
    var titleLabel: UILabel? { _titleLabel }
    var imageView: UIImageView? { _imageView }
    
    private var _titleLabel: UILabel?
    private var _imageView: UIImageView?

    func show(duration: TimeInterval, completed: ((_ finished: Bool) -> Void)? = nil) {
        
        UIApplication.shared.keyWindow?.subviews.forEach {
            if $0.isKind(of: NoticeBar.self) {
                $0.removeFromSuperview()
            }
        }

        UIApplication.shared.keyWindow?.addSubview(self)
        self.transform = config.animationType.noticeBarViewTransform(with: frame, self.config.barStyle)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }) { (_) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                UIView.animate(withDuration: 0.4, animations: {
                    self.transform = self.config.animationType.noticeBarViewTransform(with: self.frame, self.config.barStyle)
                }) { (_) in
                    self.removeFromSuperview()
                }
            }
            
        }}
    
    init(config: NoticeBarConfig) {
        super.init(frame: config.barStyle.noticeBarProperties().viewFrame)
        self.backgroundColor = config.backgroundColor
        self.config = config
        self.layer.shadowOffset = CGSize(width: 0, height: config.barStyle.noticeBarProperties().shadowOffsetY)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.44
        configSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configSubviews() {
        _titleLabel = UILabel()
        _titleLabel?.text = config.title
        _titleLabel?.textColor = config.textColor
        _titleLabel?.minimumScaleFactor = config.barStyle.noticeBarProperties().fontSizeScaleFactor
        _titleLabel?.adjustsFontSizeToFitWidth = true
        _titleLabel?.font = config.barStyle.noticeBarProperties().textFont
        addSubview(_titleLabel!)
        
        var titleLabelOriginX: CGFloat = 0
        var titleLabelOriginY: CGFloat = 0
        var titleLabelHeight: CGFloat = 0
        var titleLabelWidth: CGFloat = 0
        if let image = config.image, config.barStyle != .statusBar {
            _imageView = UIImageView.init(image: image)
            _imageView?.contentMode = .scaleAspectFill
            addSubview(_imageView!)
            let imageViewW: CGFloat = 25
            let imageViewX = config.margin + 10
            let imageViewY = config.barStyle.noticeBarOriginY(superViewHeight: frame.height, imageViewW)
            _imageView?.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewW)
            
            titleLabelOriginX = _imageView!.frame.maxX + config.margin
            titleLabelOriginY = _imageView!.frame.origin.y
            titleLabelHeight = _imageView!.frame.size.height
            titleLabelWidth = UIScreen.main.bounds.width - titleLabelOriginX - config.margin
            _titleLabel?.textAlignment = .left
        } else {
            _titleLabel?.textAlignment = .center
            titleLabelHeight = 25
            titleLabelWidth = UIScreen.main.bounds.width - 2 * config.margin
            titleLabelOriginX = config.margin
            titleLabelOriginY = config.barStyle.noticeBarOriginY(superViewHeight: frame.height, titleLabelHeight)
            
        }
        
        _titleLabel?.frame = CGRect(x: titleLabelOriginX, y: titleLabelOriginY, width: titleLabelWidth, height: titleLabelHeight)
        
        
        
    }
    
}
