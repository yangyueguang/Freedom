//
//  WXNewFriendViewController.swift
//  Freedom

import Foundation
protocol WXAddThirdPartFriendCellDelegate: NSObjectProtocol {
    func addThirdPartFriendCellDidSelectedType(_ thirdPartFriendType: String)
}
//  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
private let TLThirdPartFriendTypeContacts = "1"
private let TLThirdPartFriendTypeQQ = "2"
private let TLThirdPartFriendTypeGoogle = "3"
class WXAddThirdPartFriendCell: WXTableViewCell {
    weak var delegate: WXAddThirdPartFriendCellDelegate
    var thridPartItems: [Any] = []
    private var itemsDic: [AnyHashable : Any] = [:]
    private var contacts: WXAddThirdPartFriendItem
    private var qq: WXAddThirdPartFriendItem
    private var google: WXAddThirdPartFriendItem

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        //if super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        setBottomLineStyle(TLCellLineStyleFill)
        if let aContacts = contacts, let aQq = qq, let aGoogle = google {
            itemsDic = [TLThirdPartFriendTypeContacts: aContacts, TLThirdPartFriendTypeQQ: aQq, TLThirdPartFriendTypeGoogle: aGoogle]
        }

    }
    func setThridPartItems(_ thridPartItems: [Any]) {
        if self.thridPartItems == thridPartItems {
            return
        }
        self.thridPartItems = thridPartItems
        var lastItem: WXAddThirdPartFriendItem
        for v: UIView in contentView.subviews {
            v.removeFromSuperview()
        }
        for i in 0..<(thridPartItems.count  0) {
            let keyStr = thridPartItems[i] as String
            let item = itemsDic[keyStr  ""] as WXAddThirdPartFriendItem
            if let anItem = item {
                contentView.addSubview(anItem)
            }
            item.mas_remakeConstraints({ make in
                make.top.and().bottom().mas_equalTo(self.contentView)
            })
            if i == 0 {
                item.mas_updateConstraints({ make in
                    make.left.mas_equalTo(self.contentView)
                })
            } else {
                item.mas_updateConstraints({ make in
                    make.left.mas_equalTo(lastItem.mas_right)
                    make.width.mas_equalTo(lastItem)
                })
            }
            if i == self.thridPartItems.count - 1 {
                item.mas_updateConstraints({ make in
                    make.right.mas_equalTo(self.contentView)
                })
            }
            lastItem = item
        }
        setNeedsDisplay()
    }
    func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        if thridPartItems.count == 2 {
            context.move(to: CGPoint(x: frame.size.width / 2.0, y: 0))
            context.addLine(to: CGPoint(x: frame.size.width / 2.0, y: frame.size.height))
        } else if thridPartItems.count == 3 {
            context.move(to: CGPoint(x: frame.size.width / 3.0, y: 0))
            context.addLine(to: CGPoint(x: frame.size.width / 3.0, y: frame.size.height))
            context.move(to: CGPoint(x: frame.size.width / 3.0 * 2, y: 0))
            context.addLine(to: CGPoint(x: frame.size.width / 3.0 * 2, y: frame.size.height))
        }
        context.strokePath()
    }
    @objc func itemButtonDown(_ item: WXAddThirdPartFriendItem) {
        if delegate && delegate.responds(to: #selector(self.addThirdPartFriendCellDidSelectedType(_:))) {
            delegate.addThirdPartFriendCellDidSelectedType(item.itemTag)
        }
    }

    // MARK: - Getter -
    func contacts() -> WXAddThirdPartFriendItem {
        if contacts == nil {
            contacts = WXAddThirdPartFriendItem(imagePath: "newFriend_contacts", andTitle: "添加手机联系人")
            contacts.itemTag = TLThirdPartFriendTypeContacts.copy()
            contacts.addTarget(self, action: #selector(self.itemButtonDown(_:)), for: .touchUpInside)
        }
        return contacts
    }
    func qq() -> WXAddThirdPartFriendItem {
        if qq == nil {
            qq = WXAddThirdPartFriendItem(imagePath: "newFriend_qq", andTitle: "添加QQ好友")
            qq.itemTag = TLThirdPartFriendTypeQQ.copy()
            qq.addTarget(self, action: #selector(self.itemButtonDown(_:)), for: .touchUpInside)
        }
        return qq
    }

    func google() -> WXAddThirdPartFriendItem {
        if google == nil {
            google = WXAddThirdPartFriendItem(imagePath: "newFriend_google", andTitle: "添加Google好友")
            google.itemTag = TLThirdPartFriendTypeGoogle.copy()
            google.addTarget(self, action: #selector(self.itemButtonDown(_:)), for: .touchUpInside)
        }
        return google
    }

}
class WXNewFriendSearchViewController: WXTableViewController, UISearchResultsUpdating {
    // MARK: - Delegate -
    //MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
    }
}
class WXAddThirdPartFriendItem: UIButton {
    var itemTag = ""

    init(imagePath: String, andTitle title: String) {
    }

    private var iconImageView: UIImageView
    private var textLabel: UILabel

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func iconImageView() -> UIImageView {
        if iconImageView == nil {
            iconImageView = UIImageView()
        }
        return iconImageView
    }

    var textLabel: UILabel {
        if textLabel == nil {
            textLabel = UILabel()
            textLabel.font = UIFont.systemFont(ofSize: 12.0)
        }
        return textLabel
    }
    init(imagePath: String, andTitle title: String) {
        super.init(frame: CGRect.zero)

        iconImageView.image = UIImage(named: imagePath  "")
        textLabel.text = title
        addSubview(iconImageView)
        if let aLabel = textLabel {
            addSubview(aLabel)
        }
        p_addMasonry()

    }

    // MARK: - Pirvate Methods -
    func p_addMasonry() {
        iconImageView.mas_makeConstraints({ make in
            make.top.mas_equalTo(self).mas_offset(10)
            make.centerX.mas_equalTo(self)
        })
        textLabel.mas_makeConstraints({ make in
            make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_equalTo(5)
            make.centerX.mas_equalTo(self.iconImageView)
        })
    }
}
class WXNewFriendViewController: WXTableViewController, UISearchBarDelegate, WXAddThirdPartFriendCellDelegate {
    private var searchController: WXSearchController
    private var searchVC: WXNewFriendSearchViewController

    func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "新的朋友"
        view.backgroundColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar

        let rightBarButton = UIBarButtonItem(title: "添加朋友", style: .plain, target: self, action: #selector(WXNewFriendViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton

        registerCellClass()
    }
    func rightBarButtonDown(_ sender: UIBarButtonItem) {
        let addFriendVC = WXAddFriendViewController()
        hidesBottomBarWhenPushed = true
        navigationController.pushViewController(addFriendVC, animated: true)
    }

    // MARK: - Getter -
    var searchController: UISearchController {
        if searchController == nil {
            searchController = WXSearchController(searchResultsController: searchVC())
            searchController.searchResultsUpdater = searchVC()
            searchController.searchBar.placeholder = "微信号/手机号"
            searchController.searchBar.delegate = self
        }
        return searchController
    }

    func searchVC() -> WXNewFriendSearchViewController {
        if searchVC == nil {
            searchVC = WXNewFriendSearchViewController()
        }
        return searchVC
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func registerCellClass() {
        tableView.register(WXAddThirdPartFriendCell.self, forCellReuseIdentifier: "TLAddThirdPartFriendCell")
    }

    // MARK: - Delegate -
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TLAddThirdPartFriendCell") as WXAddThirdPartFriendCell
            cell.thridPartItems = [TLThirdPartFriendTypeContacts]
            cell.delegate = self
            return cell!
        }
        return nil
    }
    //  Converted to Swift 4 by Swiftify v4.2.17067 - https://objectivec2swift.com/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        return 60.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20.0
        }
        return 0.0
    }

    //MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }


    func addThirdPartFriendCellDidSelectedType(_ thirdPartFriendType: String) {
        if (TLThirdPartFriendTypeContacts == thirdPartFriendType) {
            let contactsVC = WXContactsViewController()
            hidesBottomBarWhenPushed = true
            navigationController.pushViewController(contactsVC, animated: true)
        } else if (TLThirdPartFriendTypeQQ == thirdPartFriendType) {
        } else if (TLThirdPartFriendTypeGoogle == thirdPartFriendType) {
        }
    }


}
