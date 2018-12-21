//
//  WXModes.swift
//  Freedom

import Foundation
func TLCreateSettingGroup(_ Header: String?,_ Footer: String?, _ Items: [WXSettingItem]) -> WXSettingGroup {
    return WXSettingGroup.createGroup(withHeaderTitle: Header ?? "", footerTitle: Footer ?? "", items: Items)
}
enum TLInfoType : Int {
    case defaultType
    case titleOnly
    case images
    case mutiRow
    case button
    case other
}

public enum TLSettingItemType : Int {
    case `default` = 0
    case titleButton
    case switchBtn
    case other
}

class WXMomentFrame: NSObject {
    var height: CGFloat = 0.0
    var heightDetail: CGFloat = 0.0
    var heightExtension: CGFloat = 0.0
}

class WXMomentDetailFrame: NSObject {
    var height: CGFloat = 0.0
    var heightText: CGFloat = 0.0
    var heightImages: CGFloat = 0.0
}

class WXMomentDetail: NSObject {
    var text = ""
    var images: [AnyHashable] = []
    var detailFrame: WXMomentDetailFrame
    func heightText() -> CGFloat {
        if text.length > 0 {
            let textHeight: CGFloat = text.boundingRect(with: CGSize(width: APPW - 70.0, height: MAXFLOAT), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)], context: nil).size.height
            //: 浮点数会导致部分cell顶部多出来一条线，莫名其妙！！！
            return Double(Int(textHeight)) + 1.0
        }
        return 0.0
    }
    func heightImages() -> CGFloat {
        var height: CGFloat = 0.0
        if images.count > 0 {
            if text.length > 0 {
                height += 7.0
            } else {
                height += 3.0
            }
            let space: CGFloat = 4.0
            if images.count == 1 {
                height += APPW - 70.0 * 0.6 * 0.8
            } else {
                let row: Int = (images.count / 3) + (images.count % 3 == 0 ? 0 : 1)
                height += APPW - 70.0 * 0.31 * Double(row) + space * CGFloat((row - 1))
            }
        }
        return height
    }
    func detailFrame() -> WXMomentDetailFrame {
        if detailFrame == nil {
            detailFrame = WXMomentDetailFrame()
            detailFrame.height = 0.0
            detailFrame.heightText = heightText()
            detailFrame.height += detailFrame.heightText
            detailFrame.heightImages = heightImages()
            detailFrame.height += detailFrame.heightImages
        }
        return detailFrame
    }

}

class WXMomentExtensionFrame: NSObject {
    var height: CGFloat = 0.0
    var heightLiked: CGFloat = 0.0
    var heightComments: CGFloat = 0.0
}

class WXMomentExtension: NSObject {
    var likedFriends: [AnyHashable] = []
    var comments: [AnyHashable] = []
    var extensionFrame: WXMomentExtensionFrame
    init() {
        super.init()

        WXMomentExtension.mj_setupObjectClass(inArray: {
            return ["likedFriends": "TLUser", "comments": "TLMomentComment"]
        })

    }

    func heightLiked() -> CGFloat {
        var height: CGFloat = 0.0
        if likedFriends.count > 0 {
            height = 30.0
        }
        return height
    }

    func heightComments() -> CGFloat {
        var height: CGFloat = 0.0
        for comment: WXMomentComment in comments {
            height += comment.commentFrame.height
        }
        return height
    }
    func extensionFrame() -> WXMomentExtensionFrame {
        if extensionFrame == nil {
            extensionFrame = WXMomentExtensionFrame()
            extensionFrame.height = 0.0
            if likedFriends.count > 0 || comments.count > 0 {
                extensionFrame.height += 5
            }
            extensionFrame.heightLiked = heightLiked()
            extensionFrame.height += extensionFrame.heightLiked
            extensionFrame.heightComments = heightComments()
            extensionFrame.height += extensionFrame.heightComments
        }
        return extensionFrame
    }
}

class WXMoment: NSObject {
    var momentID = ""
    var user: WXUser
    var date: Date
    var detail: WXMomentDetail
    var `extension`: WXMomentExtension
    lazy var momentFrame: WXMomentFrame = {
        let _momentFrame = WXMomentFrame()
        _momentFrame.height = 76.0
        _momentFrame.heightDetail = detail.detailFrame.height
        _momentFrame.height += WXMomentFrame.heightDetail // 正文高度
        _momentFrame.heightExtension = self.extension.extensionFrame.height
        _momentFrame.height += _momentFrame.heightExtension // 拓展高度
        return _momentFrame
    }()
    init() {
        super.init()
        WXMoment.mj_setupObjectClass(inArray: {
            return ["user": "TLUser", "detail": "TLMomentDetail", "extension": "TLMomentExtension"]
        })
    }
}

class WXMomentCommentFrame: NSObject {
    var height: CGFloat = 0.0
}

class WXMomentComment: NSObject {
    var user: WXUser
    var toUser: WXUser
    var content = ""
    var commentFrame: WXMomentCommentFrame {
        if commentFrame == nil {
            commentFrame = WXMomentCommentFrame()
            commentFrame.height = 35.0
        }
    }
    init() {
        super.init()
        WXMomentComment.mj_setupObjectClass(inArray: {
            return ["user": "TLUser", "toUser": "TLUser"]
        })
    }
}
class WXAddMenuHelper: NSObject {
    private var menuItemTypes: [String] = ["0", "1", "2", "3"]
    lazy var menuData: [WXAddMenuItem] = {
        for type: String in menuItemTypes as [String] {
            var menuData: [WXAddMenuItem] = []
            let item: WXAddMenuItem = p_getMenuItem(byType: Int(truncating: type))
            menuData.append(item)
        }
        return
    }()
    init() {
        super.init()
    }
    func p_getMenuItem(by type: TLAddMneuType) -> WXAddMenuItem {
        switch type {
        case .groupChat:
            return WXAddMenuItem.create(withType: TLAddMneuTypeGroupChat, title: "发起群聊", iconPath: "nav_menu_groupchat", className: "")
        case .addFriend:
            return WXAddMenuItem.create(withType: TLAddMneuTypeAddFriend, title: "添加朋友", iconPath: "nav_menu_addfriend", className: "TLAddFriendViewController")
        case .wallet:
            return WXAddMenuItem.create(withType: TLAddMneuTypeWallet, title: "收付款", iconPath: "nav_menu_wallet", className: "")
        case .scan:
            return WXAddMenuItem.create(withType: TLAddMneuTypeScan, title: "扫一扫", iconPath: "nav_menu_scan", className: "TLScanningViewController")
        default:
            break
        }
    }
}

class WXInfo: NSObject {
    var type = TLInfoType.defaultType
    var title = ""
    var subTitle = ""
    var subImageArray: [AnyHashable] = []
    var userInfo: Any
    var titleColor = UIColor.black
    var buttonColor = UIColor.green
    var buttonHLColor = UIColor.green
    var buttonBorderColor = UIColor.gray
    //是否显示箭头（默认YES）
    var showDisclosureIndicator = true
    //停用高亮（默认NO）
    var disableHighlight = false
    class func createInfo(withTitle title: String, subTitle: String) -> WXInfo {
        let info = WXInfo()
        info.title = title
        info.subTitle = subTitle
        return info
    }
    override init() {
        super.init()
    }
}
class WXMenuItem: NSObject {
    var iconPath = ""//左侧图标路径
    var title = ""//标题
    var subTitle = ""//副标题
    var rightIconURL = ""//副图片URL
    var showRightRedPoint = false//是否显示红点
    class func createMenu(withIconPath iconPath: String, title: String) -> WXMenuItem {
        let item = WXMenuItem()
        item.iconPath = iconPath
        item.title = title
        return item
    }
}

class WXSettingGroup: NSObject {
    var headerTitle = ""
    var footerTitle = ""
    var items: [WXSettingItem] = []//setcion元素
    private(set) var headerHeight: CGFloat = 0.0
    private(set) var footerHeight: CGFloat = 0.0
    private(set) var count: Int = 0
    class func createGroup(withHeaderTitle headerTitle: String, footerTitle: String, items: [WXSettingItem]) -> WXSettingGroup {
        let group = WXSettingGroup()
        group.headerTitle = headerTitle
        group.footerTitle = footerTitle
        group.items = items
        return group
    }
    func object(at index: Int) -> WXSettingItem {
        return items[index]
    }

    func index(of obj: WXSettingItem) -> Int {
        return items.index(of: obj) ?? 0
    }

    func remove(_ obj: WXSettingItem) {
        items.removeAll(where: { element in element == obj })
    }
    func setHeaderTitle(_ headerTitle: String) {
        self.headerTitle = headerTitle
        headerHeight = getTextHeightOfText(headerTitle, font: UIFont.systemFont(ofSize: 14.0), width: APPW - 30)
    }
    func setFooterTitle(_ footerTitle: String) {
        self.footerTitle = footerTitle
        footerHeight = getTextHeightOfText(footerTitle, font: UIFont.systemFont(ofSize: 14.0), width: APPW - 30)
    }
    func getTextHeightOfText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        if hLabel == nil {
            hLabel = UILabel(frame: UIScreen.main.bounds)
            hLabel.numberOfLines = 0
        }
        hLabel.frame = CGRect(x: hLabel.frame.origin.x, y: hLabel.frame.origin.y, width: width, height: hLabel.frame.size.height)
        hLabel.font = font
        hLabel.text = text
        return hLabel.sizeThatFits(CGSize(width: width, height: MAXFLOAT)).height
    }
    func count() -> Int {
        return items.count()
    }
}

public class WXSettingItem: NSObject {
    var title = ""
    var subTitle = ""
    var rightImagePath = ""
    var rightImageURL = ""
    var showDisclosureIndicator = true
    var disableHighlight = false
    var type = TLSettingItemType.defalut
    class func createItem(withTitle title: String) -> WXSettingItem {
        let item = WXSettingItem()
        item.title = title
        return item
    }
    init() {
        super.init()
    }

    func cellClassName() -> String {
        switch type {
        case .default:return "TLSettingCell"
        case TLSettingItemTypeTitleButton:return "TLSettingButtonCell"
        case TLSettingItemTypeSwitch:return "TLSettingSwitchCell"
        default:break
        }
        return ""
    }
}

class WXAddMenuItem: NSObject {
    var type: TLAddMneuType
    var title = ""
    var iconPath = ""
    var className = ""
    class func create(with type: TLAddMneuType, title: String, iconPath: String, className: String) -> WXAddMenuItem {
        let item = WXAddMenuItem()
        item.type = type
        item.title = title
        item.iconPath = iconPath
        item.className = className
        return item
    }
}
