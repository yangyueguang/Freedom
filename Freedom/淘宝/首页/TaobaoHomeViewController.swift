//
//  TaobaoHomeViewController.swift
//  Freedom
import UIKit
//import XExtension
class TitlesImageViewFull: UIView {
    var title: UILabel!
    var subtitle: UILabel!
    var iconview: UIImageView!
    var imageview: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        title = UILabel(frame: CGRect(x: 8, y: 8, width: frame.size.width - 20, height: 14))
        subtitle = UILabel(frame: CGRect(x: 8, y: 25, width: frame.size.width - 10, height: 12))
        iconview = UIImageView(frame: CGRect(x: 100, y: 0, width: 15, height: 14))
        imageview = UIImageView(frame: CGRect(x: 8, y: 25, width: frame.size.width, height: 20))
        imageview.contentMode = .scaleAspectFit
        iconview.contentMode = .scaleAspectFit
        title.font = UIFont.middle
        subtitle.font = UIFont.small
        title.textColor = UIColor.redx
        subtitle.textColor = UIColor.greenx
        addSubview(title)
        addSubview(subtitle)
        addSubview(iconview)
        addSubview(imageview)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class DaRenTaoCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let daren = UIButton(frame: CGRect(x: APPW / 2 - 50, y: 0, width: 100, height: 20))
        daren.setImage(TBImage.hot.image, for: .normal)
        daren.setTitle("达人淘", for: .normal)
        daren.setTitleColor(UIColor.redx, for: .normal)
        let more = UILabel(frame: CGRect(x: APPW - 80, y: 0, width: 60, height: 20))
        more.text = "更多 >"
        let mainView = UIView(frame: CGRect(x: 0, y: daren.bottom, width: APPW, height: self.height - daren.bottom - 30))
        mainView.backgroundColor = UIColor.whitex
        let height: CGFloat = (APPW - 32) / 3 + 14 + 3 + 12 + 3
        let view1 = TitlesImageViewFull(frame: CGRect(x: 8, y: 6, width: (APPW - 32) / 3, height: height))
        let view2 = TitlesImageViewFull(frame: CGRect(x: 8 + (APPW - 32) / 3 + 8, y: 6, width: (APPW - 32) / 3, height: height))
        let view3 = TitlesImageViewFull(frame: CGRect(x: 8 + (APPW - 32) / 3 + 8 + (APPW - 32) / 3 + 8, y: 6, width: (APPW - 32) / 3, height: height))
        mainView.addSubview(view1)
        mainView.addSubview(view2)
        mainView.addSubview(view3)
        view1.title.text = "红人圈"
        view1.subtitle.text = "别怕，红人圈来了"
        view1.imageview.image = Image.a.image
        view1.iconview.image = TBImage.hot.image
        view2.title.text = "视频直播"
        view2.subtitle.text = "别怕，学会保护自己!"
        view3.title.text = "搭配控"
        view3.subtitle.text = "我有我的fan"
        view2.imageview.image = Image.a.image
        view3.imageview.image = Image.a.image
        let subscrib = UILabel(frame: CGRect(x: 10, y: mainView.bottom - 20, width: APPW - 100, height: 20))
        subscrib.text = "小秘书为你精选推荐的N个达人"
        let icon = UIImageView(frame: CGRect(x: APPW - 40, y: subscrib.y, width: 30, height: 30))
        icon.image = Image.a.image
        addSubviews([daren, more, mainView, subscrib, icon])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Cell1: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image1 = UIImageView(frame: CGRect(x: 0, y: 0, width: self.width * 2 / 5.0, height:self.height))
        let image2 = UIImageView(frame: CGRect(x: image1.right + 1, y: 0, width: self.width - image1.right - 1, height: self.height / 2.0))
        let view = UIView(frame: CGRect(x: image2.x, y: image2.bottom + 1, width: image2.width, height: image2.height - 1))
        let image3 = UIImageView(frame: CGRect(x: 0, y: 0, width: (view.width - 1) / 2.0, height: view.height))
        let image4 = UIImageView(frame: CGRect(x: image3.right + 1, y: 0, width: image3.width, height: image3.height))
        view.addSubviews([image3, image4])
        addSubviews([image1, image2, view])
        image1.image = Image.logo.image
        image2.image = Image.logo.image
        image3.image = Image.logo.image
        image4.image = Image.logo.image
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class GridCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height - 60))
        iv.clipsToBounds = true
        let bgview = UIView(frame: bounds)
        bgview.layer.shadowColor = UIColor.blackx.cgColor
        bgview.layer.shadowOffset = CGSize(width: 0, height: 1)
        bgview.layer.shadowOpacity = 0.2
        bgview.layer.shadowRadius = 10
        let titleLab = UILabel(frame: CGRect(x: 0, y: iv.bottom, width: self.width, height: 40))
        titleLab.highlightedTextColor = UIColor.cd
        let priceLabel = UILabel(frame: CGRect(x: 10, y: titleLab.bottom, width: 100, height: 20))
        let flagLab = UILabel(frame: CGRect(x: self.width - 60, y: priceLabel.y, width: 40, height: 20))
        flagLab.backgroundColor = UIColor.redx
        addSubviews([bgview, iv, titleLab, priceLabel, flagLab])
        iv.image = TBImage.im4.image
        titleLab.text = "户外腰包男女士跑步运动音乐手机包轻薄贴身防水"
        flagLab.text = "热销"
        priceLabel.text = "￥19800.0"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class GridCell2: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image1 = UIImageView(frame: CGRect(x: 0, y: 0, width: self.width * 2 / 3.0, height: self.height - 40))
        let image2 = UIImageView(frame: CGRect(x: image1.right, y: 0, width: self.width - image1.right, height: image1.height / 2))
        let image3 = UIImageView(frame: CGRect(x: image2.x, y: image2.bottom, width: image2.width, height: image2.height))
        let label1 = UILabel(frame: CGRect(x: 10, y: image1.bottom, width: self.width - 20, height: 20))
        let label2 = UILabel(frame: CGRect(x: label1.x, y: label1.bottom, width: label1.width, height: label1.height))
        label2.font = Font(13)
        addSubviews([image1, image2, image3, label1, label2])
        image1.image = Image.logo.image
        image2.image = Image.logo.image
        image3.image = Image.logo.image
        label1.text = "【生活家--爱的杂货店"
        label2.text = "115.5万人正在逛店"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class GridCell3: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let iv = UIImageView(frame: CGRect(x: 10, y: 10, width: self.width - 20, height: self.width - 20))
        iv.layer.cornerRadius = (APPW / 5 - 8 / 5 - 20) / 2
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        let name = UILabel(frame: CGRect(x: 0, y: iv.bottom, width: self.width, height: 20))
        name.textAlignment = .center
        name.text = "天猫来了"
        addSubviews([iv, name])
        iv.image = Image.a.image
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HotShiChangCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let dataArr = [["title": "内衣", "subtitle": "性感装备", "image": "taobao06.jpg", "icon": ""], ["title": "数码", "subtitle": "潮流新机", "image": "taobao06.jpg", "icon": ""], ["title": "运动", "subtitle": "潮流新品", "image": "taobao07.jpg", "icon": ""], ["title": "家电", "subtitle": "爆款现货抢", "image": "taobao06.jpg", "icon": ""], ["title": "美女", "subtitle": "暖被窝女神", "image": "taobao07.jpg", "icon": ""], ["title": "质+", "subtitle": "休息裙", "image": "taobao06.jpg", "icon": ""], ["title": "中老年", "subtitle": "巧策", "image": "taobao07.jpg", "icon": ""], ["title": "篮球公园", "subtitle": "虎扑识货", "image": "taobao06.jpg", "icon": ""]]
        let titleButton = UIButton(frame: CGRect(x: self.width / 2 - 50, y: 0, width: 100, height: 20))
        titleButton.setTitle("热门市场", for: .normal)
        titleButton.setImage(TBImage.hot.image, for: .normal)
        let more = UILabel(frame: CGRect(x: self.width - 80, y: 0, width: 60, height: 20))
        more.text = "更多 >"
        let mainView = UIView(frame: CGRect(x: 0, y: titleButton.bottom, width: self.width, height: self.width - titleButton.bottom - 80))
        mainView.backgroundColor = UIColor.clear
        let view1 = TitlesImageViewFull(frame: CGRect(x: 0, y: 0, width: (APPW - 1) / 2, height: 120))
        let view2 = TitlesImageViewFull(frame: CGRect(x: (APPW - 1) / 2 + 1, y: 0, width: (APPW - 1) / 2, height: 120))
        view2.backgroundColor = UIColor.whitex
        view1.backgroundColor = view2.backgroundColor
        mainView.addSubview(view1)
        mainView.addSubview(view2)
        view1.title.text = "家具"
        view1.subtitle.text = "尖货推荐"
        view2.title.text = "女装"
        view2.subtitle.text = "新品推荐"
        view1.imageview.image = TBImage.im4.image
        view2.imageview.image = TBImage.im4.image
        let footimage = UIImageView(frame: CGRect(x: 0, y: mainView.bottom, width: self.width, height: 80))
        footimage.image = TBImage.im4.image
        addSubviews([titleButton, more, mainView, footimage])
        var view: TitlesImageViewFull?
        //当前i的数据
        var x: CGFloat = 0
        var y: CGFloat = 0
        var row: Int = 0
        var col: Int = 0
        let width: CGFloat = CGFloat((APPW - 3) / 4)
        //间隔为1，4列，总间隔3
        let height: CGFloat = 100
        for i in 0..<dataArr.count {
            let dic = dataArr[i]
            view = TitlesImageViewFull(frame: CGRect.zero)
            view?.isUserInteractionEnabled = true
            if i % 4 == 0 {
                row = i / 4
                print("行 (i / 4)")
            }
            col = i % 4
            print(" 列  (i % 4)")
            x = CGFloat((APPW - 3.0) / 4.0 * CGFloat(i) + CGFloat(col) - CGFloat(row) * (APPW - 3.0))
            y = CGFloat(120.0 + CGFloat(row) * 1 + 1) + CGFloat(row) * height
            view?.frame = CGRect(x: x, y: y, width: width, height: height)
            view?.title.text = dic["title"]
            view?.subtitle.text = dic["subtitle"]
            view?.imageview.image = UIImage(named: dic["image"]!)
            view?.backgroundColor = UIColor.whitex
            mainView.addSubview(view!)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Headview1: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let scroll = UIScrollView(frame: bounds)
        scroll.contentSize = CGSize(width: APPW * 2, height: APPW / 4)
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        let image1 = UIImageView(frame: CGRect(x: 0, y: 0, width: APPW, height: APPW / 4))
        let image2 = UIImageView(frame: CGRect(x: APPW, y: 0, width: APPW, height: APPW / 4))
        image1.image = TBImage.im4.image
        image2.image = TBImage.im4.image
        scroll.addSubview(image1)
        scroll.addSubview(image2)
        addSubview(scroll)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Headview2: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let icon = UIImageView(frame: CGRect(x: 0, y: 10, width: 40, height: 40))
        let title = UILabel(frame: CGRect(x: icon.right, y: 0, width: 200, height: 20))
        let subscrib = UILabel(frame: CGRect(x: title.x, y: title.bottom, width: title.width, height: 20))
        contentMode = .center
        addSubviews([icon, title, subscrib])
        icon.image = TBImage.xin.image
        title.text = "猜你喜欢的"
        subscrib.text = "今日11：00更新"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Headview3: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let line = UIView(frame: CGRect(x: 0, y: 20, width: APPW, height: 1))
        line.backgroundColor = UIColor.back
        let lable = UILabel(frame: CGRect(x: 100, y: 10, width: 300, height: 20))
        lable.textAlignment = .center
        lable.text = "实时推荐最适合你的宝贝"
        lable.backgroundColor = UIColor.back
        contentMode = .center
        addSubviews([line, lable])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Footview0: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: self.height, height: self.height))
        icon.image = TBImage.im4.image
        let mainview = UIView(frame: CGRect(x: icon.right + 1, y: 0, width: self.width - icon.right - 1, height: self.height))
        let scroll = UIScrollView()
        scroll.frame = CGRect(x: 0, y: 0, width: APPW - 50 * 3 / 2, height: 50)
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isScrollEnabled = false
        mainview.addSubview(scroll)
        let ttv1 = UIView(frame: CGRect(x: 0, y: 50 * 0, width: APPW - 50 * 3 / 2, height: 50))
        let ttv2 = UIView(frame: CGRect(x: 0, y: 50 * 1, width: APPW - 50 * 3 / 2, height: 50))
        ttv1.backgroundColor = UIColor.yellowx
        ttv2.backgroundColor = UIColor.greenx
        scroll.addSubview(ttv1)
        scroll.addSubview(ttv2)
        scroll.contentSize = CGSize(width: APPW - 50 * 3 / 2, height: 50 * 2)
        scroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        addSubviews([icon, mainview])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Footview1: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let name = UILabel(frame: CGRect(x: 10, y: 10, width: APPW - 20, height: 20))
        name.textAlignment = .center
        name.text = "宝贝已经看完了，18：00后更新"
        let image = UIImageView(frame: CGRect(x: 10, y: name.bottom, width: name.width, height: 70))
        image.image = TBImage.im4.image
        addSubviews([name, image])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//FIXME: 以下是正式的VC
final class TaobaoHomeViewController: TaobaoBaseViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var grid: UICollectionView!
    var dataArr = [Any]()
    var sectionArr = [Any]()
    var msgLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArr = [Any]()
        sectionArr = [Any]()
        navigationController?.isNavigationBarHidden = false
        let searchBar = UISearchBar()
        searchBar.placeholder = "输入搜索关键字"
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.tintColor = UIColor.grayx
        let image = TBImage.message.image.withRenderingMode(.alwaysOriginal)
        let leftI = UIBarButtonItem(image: TBImage.scanner.image, style: .done, target: nil, action: nil)
        let rightI = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = leftI
        navigationItem.rightBarButtonItem = rightI
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.headerReferenceSize = CGSize(width: 320, height: 40)
        grid = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        view.addSubview(grid)
        grid.backgroundColor = UIColor.back
        grid.delegate = self
        grid.dataSource = self
        grid.register(GridCell.self, forCellWithReuseIdentifier: GridCell.identifier)
        grid.register(GridCell2.self, forCellWithReuseIdentifier: GridCell2.identifier)
        grid.register(GridCell3.self, forCellWithReuseIdentifier: GridCell3.identifier)
        grid.register(Cell1.self, forCellWithReuseIdentifier: Cell1.identifier)
        grid.register(HotShiChangCell.self, forCellWithReuseIdentifier: HotShiChangCell.identifier)
        grid.register(DaRenTaoCell.self, forCellWithReuseIdentifier: DaRenTaoCell.identifier)
        grid.register(Headview1.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Headview1.identifier)
        grid.register(Headview2.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Headview2.identifier)
        grid.register(Headview3.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Headview3.identifier)
        grid.register(Footview0.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Footview0.identifier)
        grid.register(Footview1.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Footview1.identifier)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 10
        }
        if section == 1 {
            return 6
        }
        if section == 2 {
            return 4
        }
        if section == 3 {
            return 10
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var gridcell: UICollectionViewCell? = nil
        if indexPath.section == 0 {
            let cell = collectionView.dequeueCell(GridCell3.self, for: indexPath)
            gridcell = cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueCell(Cell1.self, for: indexPath)
                gridcell = cell
            } else if indexPath.row == 1 {
                let cell = collectionView.dequeueCell(Cell1.self, for: indexPath)
                gridcell = cell
            } else if indexPath.row == 2 {
                let cell = collectionView.dequeueCell(Cell1.self, for: indexPath)
                gridcell = cell
            } else if indexPath.row == 3 {
                let cell = collectionView.dequeueCell(Cell1.self, for: indexPath)
                gridcell = cell
            } else if indexPath.row == 4 {
                let cell = collectionView.dequeueCell(HotShiChangCell.self, for: indexPath)
                gridcell = cell
            } else if indexPath.row == 5 {
                let cell = collectionView.dequeueCell(DaRenTaoCell.self, for: indexPath)
                gridcell = cell
            } else {
            }
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueCell(GridCell2.self, for: indexPath)
            gridcell = cell
        } else {
            //可以加载更多的那个cell
            let cell = collectionView.dequeueCell(GridCell.self, for: indexPath)
            gridcell = cell
        }
        if let aGridcell = gridcell {
            return aGridcell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView? = nil
        if indexPath.section == 0 {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueHeadFoot(Headview1.self, kind: kind, for: indexPath)
                reusableview = headerView
            }
            if kind == UICollectionView.elementKindSectionFooter {
                let footview = collectionView.dequeueHeadFoot(Footview0.self, kind: kind, for: indexPath)
                reusableview = footview
            }
        } else if indexPath.section == 2 {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueHeadFoot(Headview2.self, kind: kind, for: indexPath)
                reusableview = headerView
            }
        } else if indexPath.section == 3 {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueHeadFoot(Headview3.self, kind: kind, for: indexPath)
                reusableview = headerView
            }
            if kind == UICollectionView.elementKindSectionFooter {
                let footview = collectionView.dequeueHeadFoot(Footview1.self, kind: kind, for: indexPath)
                reusableview = footview
            }
        }
        if let aReusableview = reusableview {
            return aReusableview
        }
        return UICollectionReusableView()
    }
    //item 宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            //9宫格组//减1去除误差
            //DLog(@"########%f", (SCREEN_W-4-4-1)/5;
            return CGSize(width: (APPW - 4 - 4 - 1) / 5, height: APPW / 5 + 20)
        }
        if indexPath.section == 1 {
            //乱七八糟组
            if indexPath.row == 0 {
                return CGSize(width: APPW, height: APPW * ((190) / 375.0) + 8)
            }
            if indexPath.row == 4 {
                return CGSize(width: APPW, height: CGFloat(8 + 30 + 1 + 120 + 1 + 70 + 2 * 101))
            }
            if indexPath.row == 5 {
                return CGSize(width: APPW, height: (APPW - 32) / 3 + 8 + 30 + 8 + 42 + 40)
            }
            return CGSize(width: APPW, height: APPW * ((190) / 375.0) + 8)
        }
        if indexPath.section == 2 {
            //喜欢组
            return CGSize(width: APPW / 2 - 4 / 2, height: (APPW / 2 - 4 / 2) * 2 / 3 + 48)
        }
        if indexPath.section == 3 {
            //推荐组
            return CGSize(width: APPW / 2 - 4 / 2, height: APPW / 2 - 4 / 2 + 80)
        }
        return CGSize(width: 0, height: 0)
    }
    //head 宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: APPW, height: APPW / 4)
        }
        //图片滚动的宽高
        if section == 2 {
            return CGSize(width: APPW, height: 50)
        }
        //猜你喜欢的宽高
        if section == 3 {
            return CGSize(width: APPW, height: 35)
        }
        //推荐适合的宽高
        return CGSize(width: 0, height: 0)
    }
    //foot 宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: APPW, height: 50)
        }
        //淘宝头条的宽高
        if section == 3 {
            return CGSize(width: APPW, height: 110)
        }
        //最底部view的宽高
        return CGSize.zero
    }
    //边缘间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        }
        return .zero
    }
    //x 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //y 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 0
        }
        if section == 2 {
            return 4
        }
        return 2
    }
    //:FIXME collectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            return
        }
        noticeSuccess("你选择的是\(indexPath.section)，\(indexPath.row)")
        print("你选择的是\(indexPath.section)，\(indexPath.row)")
    }
}
