//
//  Freedom
import UIKit
//import XExtension
import MJRefresh
class IqiyiImageScrollView: UIView, UIScrollViewDelegate {
    var scrollView: UIScrollView = UIScrollView()
    var pageControl: UIPageControl = UIPageControl()
    var imgArray = [String]()
    var timer: Timer?
    var pageNumber: Int = 0
    override init(frame:CGRect){
        super.init(frame: frame)
        scrollView.frame = frame
        scrollView.contentSize = CGSize(width: 4 * APPW, height: frame.size.height)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        for i in 0..<10 {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: CGFloat(i) * APPW, y: 0, width: APPW, height: frame.size.height)
            imageView.tag = i + 10
            imageView.isUserInteractionEnabled = true
            scrollView.addSubview(imageView)
        }
        addSubview(scrollView)
        pageControl.frame = CGRect(x: APPW / 2 - 40, y: frame.size.height - 40, width: 80, height: 30)
        pageControl.currentPage = 0
        pageControl.numberOfPages = 6
        addSubview(pageControl)
        addTimer()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setImageArray(_ imageArray: [String]) {
        pageNumber = Int(imageArray.count)
        scrollView.contentSize = CGSize(width: CGFloat(CGFloat(imageArray.count) * APPW), height: frame.size.height)
        pageControl.numberOfPages = imageArray.count
        //添加图片
        for i in 0..<imageArray.count {
            let imageView = scrollView.viewWithTag(i + 10) as? UIImageView
            let imageName = "\(imageArray[i])"
            imageView?.sd_setImage(with: URL(string: imageName), placeholderImage: IQYImage.holder.image)
        }
    }
    func addTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.netxPage), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    @objc func netxPage() {
        var page = pageControl.currentPage
        if page == pageNumber - 1 {
            page = 0
        } else {
            page += 1
        }
        //滚动scrollview
        let x = CGFloat(page) * scrollView.frame.size.width
        scrollView.contentOffset = CGPoint(x: x, y: 0)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewW: CGFloat = scrollView.frame.size.width
        let x: CGFloat = scrollView.contentOffset.x
        let page = Int((x + scrollViewW / 2) / scrollViewW)
        pageControl.currentPage = page
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    deinit {
        removeTimer()
    }
}
class IqiyiImageScrollCell: BaseTableViewCell<[String]> {
    var imageScrollView = IqiyiImageScrollView(frame: CGRect(x: 0, y: 0, width: APPW, height: 100))
    override func initUI() {
        viewModel.subscribe(onNext: { (model) in
            self.imageScrollView.setImageArray(model)
        }).disposed(by: disposeBag)
    }
}

class IqiyiDiscoverCell:BaseTableViewCell<IqiyiDiscoverModel> {
    override func initUI() {
        selectionStyle = .none
        viewModel.subscribe(onNext: {[weak self] (model) in
            self?.textLabel?.text = model.title
            self?.imageView?.kf.setImage(with: URL(string: model.module_icon ?? ""))
        }).disposed(by: disposeBag)
    }
}
final class IqiyiDiscoverViewController: IqiyiBaseViewController {
    var discoverTableView:UITableView!
    var dataSource = [IqiyiDiscoverModel]()
    var imageArray = [String]()
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let w: CGFloat = APPW * 0.8
        let searchButton = UIButton(type: .custom)
        searchButton.imageView?.contentMode = .center
        searchButton.titleLabel?.font = UIFont.small
        searchButton.setTitleColor(UIColor.blackx, for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: w, height: 30)
        searchButton.setBackgroundImage(IQYImage.groupCell.image, for: .normal)
        searchButton.setImage(IQYImage.searchSmall.image, for: .normal)
        searchButton.setTitle("请输入：港囧，夏洛特烦恼，徐峥等", for: .normal)
        searchButton.addTarget(self, action: #selector(self.searchButtonClick), for: .touchUpInside)
        searchButton.setTitleColor(UIColor.grayx, for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchButton)
        let rightItem = UIBarButtonItem(image: Image.navi.image, style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightItem
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPH - 64), style: .plain)
//        tableView.delegate = self
//        tableView.dataSource = self
        //将系统的Separator左边不留间隙
        tableView.separatorInset = UIEdgeInsets.zero
        discoverTableView = tableView
        view.addSubview(discoverTableView)
        discoverTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {() -> Void in
            let urlStr = "urlWithDiscoverData"
            print(urlStr)
        })
        discoverTableView.mj_header.beginRefreshing()
    }
    func searchButtonClick() {
        let searchVC = IqiyiSearchHistoryViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 280
        } else {
            return 40
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell = tableView.dequeueCell(IqiyiImageScrollCell.self)
            cell.viewModel.onNext(imageArray)
            return cell
        } else {
            let cell = IqiyiDiscoverCell(style: .default, reuseIdentifier: IqiyiDiscoverCell.identifier)
//        cell.setDiscoverModel = dataSource[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let webVC = IqiyiWebViewController()
            webVC.urlStr = TestWebURL
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    // MARK: - JFImageScrollViewDelegate
    func didSelectImage(at index: Int) {
        let _: IqiyiDiscoverModel? = dataSource[0] as? IqiyiDiscoverModel
        let code = "dsk"// disM?.items[index]["video_id"] as? String
        let videoVC = IqiyiVideoDetailViewController()
        videoVC.iid = code
        navigationController?.pushViewController(videoVC, animated: true)
    }
        
}
