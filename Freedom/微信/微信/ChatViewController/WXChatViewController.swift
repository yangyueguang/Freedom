//
//  WXChatViewController.swift
//  Freedom
import XExtension
import SnapKit
import MWPhotoBrowser
import Foundation
extension UIImagePickerController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor(46.0, 49.0, 50.0, 1.0)
        navigationBar.tintColor = UIColor.white
        view.backgroundColor = UIColor.lightGray
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.5)]
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
class WXMoreKBHelper: NSObject {
    var chatMoreKeyboardData: [TLMoreKeyboardItem] = []
    override init() {
        super.init()
        let imageItem = TLMoreKeyboardItem.create(by: .image, title: "照片", imagePath: "moreKB_image")
        let cameraItem = TLMoreKeyboardItem.create(by: .camera, title: "拍摄", imagePath: "moreKB_video")
        let videoItem = TLMoreKeyboardItem.create(by: .video, title: "小视频", imagePath: "moreKB_sight")
        let videoCallItem = TLMoreKeyboardItem.create(by: .videoCall, title: "视频聊天", imagePath: "moreKB_video_call")
        let walletItem = TLMoreKeyboardItem.create(by: .wallet, title: "红包", imagePath: "moreKB_wallet")
        let transferItem = TLMoreKeyboardItem.create(by: .transfer, title: "转账", imagePath: "moreKB_pay")
        let positionItem = TLMoreKeyboardItem.create(by: .position, title: "位置", imagePath: "moreKB_location")
        let favoriteItem = TLMoreKeyboardItem.create(by: .favorite, title: "收藏", imagePath: "moreKB_favorite")
        let businessCardItem = TLMoreKeyboardItem.create(by: .businessCard, title: "个人名片", imagePath: "moreKB_friendcard")
        let voiceItem = TLMoreKeyboardItem.create(by: .voice, title: "语音输入", imagePath: "moreKB_voice")
        let cardsItem = TLMoreKeyboardItem.create(by: .cards, title: "卡券", imagePath: "moreKB_wallet")
        chatMoreKeyboardData.append(contentsOf: [imageItem, cameraItem, videoItem, videoCallItem, walletItem, transferItem, positionItem, favoriteItem, businessCardItem, voiceItem, cardsItem])
    }
}
class WXChatViewController: WXChatBaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    static let shared = WXChatViewController()
    private var moreKBhelper = WXMoreKBHelper()
    private var emojiKBHelper = WXUserHelper.shared
    override var partner: WXChatUserProtocol? {
        didSet {
            if partner?.chat_userType == TLChatUserType.user.rawValue {
                rightBarButton.image = UIImage(named: "nav_chat_single")
            } else if partner?.chat_userType == TLChatUserType.group.rawValue {
                rightBarButton.image = UIImage(named: "nav_chat_multi")
            }
        }
    }
    private lazy var rightBarButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(self.rightBarButtonDown(_:)))
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = rightBarButton
        user = WXUserHelper.shared.user as WXChatUserProtocol
        self.moreKeyboard.chatMoreKeyboardData = moreKBhelper.chatMoreKeyboardData
        emojiKBHelper.emojiGroupDataComplete({ emojiGroups in
            self.moreKeyboard.chatMoreKeyboardData = self.moreKBhelper.chatMoreKeyboardData
            self.emojiKBHelper.emojiGroupDataComplete({ emojiGroups in
                self.emojiKeyboard.emojiGroupData = [emojiGroups]
            })
        })
    }
    @objc func rightBarButtonDown(_ sender: UINavigationBar) {
        if partner?.chat_userType == TLChatUserType.user.rawValue {
            let chatDetailVC = WXChatDetailViewController()
            chatDetailVC.user = partner as! WXUser
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(chatDetailVC, animated: true)
        } else if partner?.chat_userType == TLChatUserType.group.rawValue {
            let chatGroupDetailVC = WXCGroupDetailViewController()
            chatGroupDetailVC.group = partner as! WXGroup
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(chatGroupDetailVC, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPicking image: UIImage, editingInfo: [String : Any]) {
        picker.dismiss(animated: true) {
            self.sendImageMessage(image)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let image = info[.originalImage] as! UIImage
            self.sendImageMessage(image)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func moreKeyboard(_ keyboard: Any, didSelectedFunctionItem funcItem: TLMoreKeyboardItem) {
        if funcItem.type == .camera || funcItem.type == .image {
            let imagePickerController = UIImagePickerController()
            if funcItem.type == .camera {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imagePickerController.sourceType = .camera
                } else {
                    self.noticeError("相机初始化失败")
                    return
                }
            } else {
                imagePickerController.sourceType = .photoLibrary
            }
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        } else {
            self.noticeInfo("选中”\(funcItem.title)“ 按钮")
        }
    }
    func emojiKeyboardEmojiEditButtonDown() {
//        let expressionVC = WXExpressionViewController()
//        let navC = WXNavigationController(rootViewController: expressionVC)
//        present(navC, animated: true)
    }

    func emojiKeyboardMyEmojiEditButtonDown() {
//        let myExpressionVC = WXMyExpressionViewController()
//        let navC = WXNavigationController(rootViewController: myExpressionVC)
//        present(navC, animated: true)
    }
    override func didClickedUserAvatar(_ user: WXUser) {
        let detailVC = WXFriendDetailViewController()
        detailVC.user = user
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    override func didClickedImageMessages(_ imageMessages: [WXImageMessage], at index: Int) {
        var data: [MWPhoto] = []
        for message: WXImageMessage in imageMessages {
            var url: URL?
            let imagePath = message.content.path
            if !imagePath.isEmpty {
                let imagePatha = FileManager.pathUserChatImage(imagePath)
                url = URL(fileURLWithPath: imagePatha)
            } else {
                url = URL(string: message.content.url)
            }
            let photo = MWPhoto(url: url)
            data.append(photo!)
        }
        if let browser = MWPhotoBrowser(photos: data) {
            browser.displayNavArrows = true
            browser.setCurrentPhotoIndex(UInt(index))
            let broserNavC = WXNavigationController(rootViewController: browser)
            present(broserNavC, animated: false)
        }
    }
}
