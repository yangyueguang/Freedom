//
//  WXTagsViewController.swift
//  Freedom

import Foundation
class WXTagCell: WXTableViewCell {
    var titleLabel = UILabel()
    var title: String = "" {
        get {
            return _title
        }
        set(title) {
            _title = title
            titleLabel.text = title
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        leftSeparatorSpace = 15
        contentView.addSubview(titleLabel)
//        titleLabel.mas_makeConstraints({ make in
//            make.left.mas_equalTo(self.leftSeparatorSpace)
//            make.right.mas_lessThanOrEqualTo(-self.leftSeparatorSpace)
//            make.centerY.mas_equalTo(self.contentView)
//        })
    }
}
class WXTagsViewController: WXTableViewController {
    var data: [AnyHashable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "标签"
        view.backgroundColor = UIColor.white
        registerCellClass()
        let rightBarButton = UIBarButtonItem(title: "新建", style: .plain, target: self, action: #selector(WXTagsViewController.rightBarButtonDown(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        data = WXFriendHelper.shared.tagsData
    }

    // MARK: - Event Response -
    @objc func rightBarButtonDown(_ sender: UIBarButtonItem) {
    }
    func registerCellClass() {
        tableView.register(WXTagCell.self, forCellReuseIdentifier: "TLTagCell")
    }

    // MARK: - Delegate -
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = data[indexPath.row] as WXUserGroup
        let cell = tableView.dequeueReusableCell(withIdentifier: "TLTagCell") as WXTagCell
        if let aName = group.groupName {
            cell.title = String(format: "%@(%ld)", aName, Int(group.count))
        }
        cell.topLineStyle = (indexPath.row == 0 ? TLCellLineStyleFill : TLCellLineStyleNone)
        cell.bottomLineStyle = (indexPath.row == data.count - 1 ? TLCellLineStyleFill : TLCellLineStyleDefault)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
