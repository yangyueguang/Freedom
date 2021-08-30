//
//  WXFriendsViewController.swift
//  Freedom
import SnapKit
import Foundation
class WXFriendCell: BaseTableViewCell<WXUser> {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func initUI() {
        viewModel.subscribe(onNext: {[weak self] (user) in
            guard let `self` = self else { return }
            if !user.avatarPath.isEmpty {
                self.iconImageView.image = user.avatarPath.image
            } else {
                self.iconImageView.kf.setImage(with: URL(string: user.avatarURL))
            }
            self.titleLabel.text = user.showName
        }).disposed(by: disposeBag)
    }
}
class WXFriendHeaderView: UITableViewHeaderFooterView {
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    let titleLabel: UILabel = UILabel()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundView = UIView()
        backgroundView?.backgroundColor = UIColor.light
        titleLabel.font = UIFont.middle
        titleLabel.textColor = UIColor.grayx
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class WXFriendsViewController: BaseTableViewController ,UISearchBarDelegate {
    @IBOutlet weak var footLabel: UILabel!
    private lazy var searchController: WXSearchController = {
        let searchController = WXSearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = searchVC
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.delegate = self
        searchController.showVoiceButton = true
        return searchController
    }()
    private var friendHelper = WXFriendHelper.shared
    var data: [WXUserGroup] = []
    var sectionHeaders: [String] = []
    var searchVC = WXFriendSearchViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(WXFriendHeaderView.self, forHeaderFooterViewReuseIdentifier: WXFriendHeaderView.identifier)
        
        data = friendHelper.data
        sectionHeaders = friendHelper.sectionHeaders
        footLabel.text = String(format: "%ld位联系人",friendHelper.friendCount)
        friendHelper.dataChangedBlock = { data, headers, friendCount in
            self.data = data
            self.sectionHeaders = headers
            self.footLabel.text = String(format: "%ld位联系人", friendCount)
            self.tableView.reloadData()
        }
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.grayx
        tableView.backgroundColor = UIColor.whitex
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = UIColor.back
        tableView.tableHeaderView = searchController.searchBar
    }
    @IBAction func rightBarButtonDown(_ sender: UIBarButtonItem) {
        let addFriendVC = WXAddFriendViewController.storyVC(.wechat)
        navigationController?.pushViewController(addFriendVC, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(data[section].users.count)
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let view = tableView.dequeueHeadFootView(view: WXFriendHeaderView.self)
        view?.title = data[section].groupName
        return view
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(WXFriendCell.self)
        let group = data[indexPath.section]
        return cell
    }
    // 拼音首字母检索
    override func sectionIndexTitles(for tableView: UITableView) -> [String] {
        return sectionHeaders
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if index == 0 {
            self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height), animated: false)
            return -1
        }
        return index
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = data[indexPath.section].users[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchVC.friendsData = WXFriendHelper.shared.friendsData
        UIApplication.shared.statusBarStyle = .default
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tabBarController?.tabBar.isHidden = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        noticeInfo("语音搜索按钮")
    }
}
