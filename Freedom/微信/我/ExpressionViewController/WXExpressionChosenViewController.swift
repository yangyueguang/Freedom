//
//  WXExpressionChosenViewController.swift
//  Freedom
import SnapKit
import MJRefresh
//import XCarryOn
//import XExtension
import Foundation
protocol WXExpressionCellDelegate: NSObjectProtocol {
    func expressionCellDownloadButtonDown(_ group: TLEmojiGroup)
}
protocol WXExpressionBannerCellDelegate: NSObjectProtocol {
    func expressionBannerCellDidSelectBanner(_ item: TLEmojiGroup)
}
class WXExpressionCell: BaseTableViewCell<TLEmojiGroup> {
    weak var delegate: WXExpressionCellDelegate?
    private lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.backgroundColor = UIColor.clear
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 5.0
        return iconImageView
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.big
        return titleLabel
    }()
    private lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = UIFont.small
        detailLabel.textColor = UIColor.grayx
        return detailLabel
    }()
    private lazy var tagView: UIImageView = {
        let tagView = UIImageView()
        tagView.image = WXImage.corner.image
        tagView.isHidden = true
        return tagView
    }()
    private lazy var downloadButton: UIButton = {
        let downloadButton = UIButton()
        downloadButton.setTitle("下载", for: .normal)
        downloadButton.titleLabel?.font = UIFont.middle
        downloadButton.setTitleColor(UIColor.greenx, for: .normal)
        downloadButton.layer.masksToBounds = true
        downloadButton.layer.cornerRadius = 3.0
        downloadButton.layer.borderWidth = 1.0
        downloadButton.layer.borderColor = UIColor.greenx.cgColor
        downloadButton.addTarget(self, action: #selector(self.downloadButtonDown(_:)), for: .touchUpInside)
        return downloadButton
    }()
    var group: TLEmojiGroup = TLEmojiGroup() {
        didSet {
            let image = group.groupIconPath.image
            if image != nil {
                iconImageView.image = image
            } else {
                iconImageView.sd_setImage(with: URL(string: group.groupIconURL))
            }
            titleLabel.text = group.groupName
            detailLabel.text = group.groupDetailInfo
            if group.status == .downloaded {
                downloadButton.setTitle("已下载", for: .normal)
                downloadButton.layer.borderColor = UIColor.grayx.cgColor
                downloadButton.setTitleColor(UIColor.grayx, for: .normal)
            } else if group.status == .downloading {
                downloadButton.setTitle("下载中", for: .normal)
                downloadButton.layer.borderColor = UIColor.greenx.cgColor
                downloadButton.setTitleColor(UIColor.greenx, for: .normal)
            } else {
                downloadButton.setTitle("下载", for: .normal)
                downloadButton.layer.borderColor = UIColor.greenx.cgColor
                downloadButton.setTitleColor(UIColor.greenx, for: .normal)
            }
        }
    }
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(tagView)
        contentView.addSubview(downloadButton)
        p_addMasonry()
    }
    func p_addMasonry() {
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.width.equalTo(self.iconImageView.height)
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.iconImageView.snp.centerY).offset(-2.0)
            make.left.equalTo(self.iconImageView.right).offset(13.0)
            make.right.lessThanOrEqualTo(self.downloadButton.snp.left).offset(-15)
        }
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.iconImageView.snp.centerY).offset(5.0)
            make.left.equalTo(self.titleLabel)
            make.right.lessThanOrEqualTo(self.downloadButton.snp.left).offset(-15)
        }
        tagView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        downloadButton.snp.makeConstraints { make in
            make.right.equalTo(self.contentView).offset(-15)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 60, height: 26))
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func downloadButtonDown(_ sender: UIButton) {
        if group.status == .unDownload {
            group.status = .downloading
            delegate?.expressionCellDownloadButtonDown(group)
        }
    }
}


class WXExpressionBannerCell: BaseTableViewCell<Any>,WXPictureCarouselDelegate {
    weak var delegate: WXExpressionBannerCellDelegate?
    private var picCarouselView = WXPictureCarouselView()
    var data: [TLEmojiGroup] = [] {
        didSet {
            picCarouselView.data = data
        }
    }
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        picCarouselView.delegate = self
        contentView.addSubview(picCarouselView)
        picCarouselView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func pictureCarouselView(_ pictureCarouselView: WXPictureCarouselView, didSelectItem model: TLEmojiGroup) {
        delegate?.expressionBannerCellDidSelectBanner(model)
    }
}

class WXExpressionChosenViewController: BaseTableViewController,UISearchBarDelegate {
    var kPageIndex: Int = 0
    var data: [TLEmojiGroup] = []
    var bannerData: [TLEmojiGroup] = []
    var proxy = WXExpressionHelper.shared
    private lazy var searchController: WXSearchController = {
        let searchController = WXSearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = searchVC
        searchController.searchBar.placeholder = "搜索表情"
        searchController.searchBar.delegate = searchVC
        return searchController
    }()
    private var searchVC = WXExpressionSearchViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        tableView.frame = CGRect(x: 0, y: TopHeight + 20, width: APPW, height: APPH - 20 - TopHeight)
        tableView.backgroundColor = UIColor.whitex
        tableView.tableHeaderView = searchController.searchBar
        tableView.register(WXExpressionBannerCell.self, forCellReuseIdentifier: WXExpressionBannerCell.identifier)
        tableView.register(WXExpressionCell.self, forCellReuseIdentifier: WXExpressionCell.identifier)
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData))
        footer.setTitle("正在加载...", for: .refreshing)
        footer.setTitle("", for: .noMoreData)
        tableView.mj_footer = footer
        loadData(withLoadingView: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        XHud.hide()
    }
    func loadData(withLoadingView showLoadingView: Bool) {
        if showLoadingView {
            XHud.show()
        }
        kPageIndex = 1
        XNetKit.kit.requestExpressionChosenList(byPageIndex: kPageIndex, success: { data in
            XHud.hide()
            self.kPageIndex += 1
            for group: TLEmojiGroup in data {
                // 优先使用本地表情
                let localEmojiGroup = WXExpressionHelper.shared.emojiGroup(byID: group.groupID)
                if let localEmojiGroup = localEmojiGroup {
                    self.data.append(localEmojiGroup)
                } else {
                    self.data.append(group)
                }
            }
            self.tableView.reloadData()
        }, failure: { error in
            XHud.hide()
        })
        XNetKit.kit.requestExpressionChosenBannerSuccess({ data in
            self.bannerData = data
            self.tableView.reloadData()
        }, failure: { error in
        })
    }

    @objc func loadMoreData() {
        XNetKit.kit.requestExpressionChosenList(byPageIndex: kPageIndex, success: { data in
            XHud.hide()
            if data.count == 0 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer?.endRefreshing()
                self.kPageIndex += 1
                for group: TLEmojiGroup in data {
                    // 优先使用本地表情
                    let localEmojiGroup = WXExpressionHelper.shared.emojiGroup(byID: group.groupID)
                    if let localEmojiGroup = localEmojiGroup {
                        self.data.append(localEmojiGroup)
                    } else {
                        self.data.append(group)
                    }
                }
                self.tableView.reloadData()
            }
        }, failure: { error in
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            XHud.hide()
        })
    }
}
extension WXExpressionChosenViewController: WXExpressionCellDelegate, WXExpressionBannerCellDelegate {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return bannerData.count > 0 ? 2 : 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return bannerData.count > 0 ? 1 : data.count
        } else if section == 1 {
            return data.count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && bannerData.count > 0 {
            let bannerCell = tableView.dequeueCell(WXExpressionBannerCell.self)
            bannerCell.data = bannerData
            bannerCell.delegate = self
            return bannerCell
        }
        let cell = tableView.dequeueCell(WXExpressionCell.self)
        let group: TLEmojiGroup = data[indexPath.row]
        cell.group = group
        cell.delegate = self
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0 && bannerData.count == 0) || indexPath.section == 1 {
            let group = data[indexPath.row]
            let detailVC = WXExpressionDetailViewController()
            detailVC.group = group
            parent?.navigationController?.pushViewController(detailVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return bannerData.count > 0 ? 140 : 80
        } else if indexPath.section == 1 {
            return 80
        }
        return 0
    }
    //MARK: TLExpressionBannerCellDelegate
    func expressionBannerCellDidSelectBanner(_ item: TLEmojiGroup) {
        let detailVC = WXExpressionDetailViewController()
        detailVC.group = item
        parent?.navigationController?.pushViewController(detailVC, animated: true)
    }
    func expressionCellDownloadButtonDown(_ group: TLEmojiGroup) {
        group.status = .downloading
        XNetKit.kit.requestExpressionGroupDetail(byGroupID: group.groupID, pageIndex: 1, success: { data in
            group.data.removeAll()
//            group.data.append(objectsIn:data)
            XNetKit.kit.downloadExpressions(withGroupInfo: group, progress: { progress in
            }, success: { group in
                group.status = .downloaded
                let index = self.data.index(of: group) ?? -1
                if index < self.data.count {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 1)], with: .none)
                }
                WXExpressionHelper.shared.addExpressionGroup(group)
            }, failure: { group, error in

            })
        }, failure: { error in
            self.noticeError("\(group.groupName)\" 下载失败: \(error)")
        })
    }
}
