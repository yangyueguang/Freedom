//
//  TLEmojiBaseCell.swift
//  Freedom
import SnapKit
import Foundation
class TLEmojiBaseCell: UICollectionViewCell {
    var emojiItem: TLEmoji = TLEmoji()
    var bgView = UIImageView()
    var highlightImage: UIImage?
    var showHighlightImage = false
}

class TLEmojiFaceItemCell: TLEmojiBaseCell {
    private var imageView = UIImageView()
    override var emojiItem: TLEmoji {
        didSet {
            imageView.image = emojiItem.emojiName.isEmpty ? nil : UIImage(named: emojiItem.emojiName)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TLEmojiImageItemCell: TLEmojiBaseCell {
    private var imageView = UIImageView()
    override var emojiItem: TLEmoji {
        didSet {
            imageView.image = emojiItem.emojiPath.isEmpty ? nil : UIImage(named: emojiItem.emojiPath)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        highlightImage = UIImage(named: "emoji_hl_background")
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView).offset(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2) as! ConstraintOffsetTarget)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TLEmojiImageTitleItemCell: TLEmojiBaseCell {
    private var imageView = UIImageView()
    override var emojiItem: TLEmoji {
        didSet {
            imageView.image = emojiItem.emojiPath.isEmpty ? nil : UIImage(named: emojiItem.emojiPath)
            label.text = emojiItem.emojiName
        }
    }
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        highlightImage = UIImage(named: "emoji_hl_background")
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.contentView)
            make.height.equalTo(self.bgView.snp.width)
        }
        imageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.contentView).offset(3)
            make.right.equalTo(self.contentView).offset(-3)
            make.height.equalTo(self.imageView.snp.width)
        }
        label.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TLEmojiItemCell: TLEmojiBaseCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25.0)
        return label
    }()
    override var emojiItem: TLEmoji {
        didSet {
            label.text = emojiItem.emojiName
        }
    }
    override var showHighlightImage: Bool {
        didSet {
            if showHighlightImage {
                bgView.image = highlightImage
            } else {
                bgView.image = nil
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 5.0
        contentView.addSubview(label)
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TLEmojiGroupCell: UICollectionViewCell {
    var emojiGroup: TLEmojiGroup = TLEmojiGroup() {
        didSet {
            groupIconView.image = UIImage(named: emojiGroup.groupIconPath)
        }
    }
    private var groupIconView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(245.0, 245.0, 247.0, 1.0)
        selectedBackgroundView = selectedView
        contentView.addSubview(groupIconView)
        groupIconView.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.width.height.lessThanOrEqualTo(30)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: frame.size.width - 0.5, y: 5))
        context.addLine(to: CGPoint(x: frame.size.width - 0.5, y: frame.size.height - 5))
        context.strokePath()
    }
}
protocol TLEmojiGroupControlDelegate: NSObjectProtocol {
    func emojiGroupControl(_ emojiGroupControl: TLEmojiGroupControl, didSelectedGroup group: TLEmojiGroup)
    func emojiGroupControlEditButtonDown(_ emojiGroupControl: TLEmojiGroupControl)
    func emojiGroupControlEditMyEmojiButtonDown(_ emojiGroupControl: TLEmojiGroupControl)
    func emojiGroupControlSendButtonDown(_ emojiGroupControl: TLEmojiGroupControl)
}

class TLEmojiGroupControl: UIView,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var sendButtonStatus = TLGroupControlSendButtonStatus.none {
        didSet {
            if sendButtonStatus == .none {
                UIView.animate(withDuration: 1, animations: {
                    self.sendButton.snp.updateConstraints({ (make) in
                        make.right.equalToSuperview()
                    })
                    self.layoutIfNeeded()
                })
            }
            if sendButtonStatus == .none {
                UIView.animate(withDuration: 1, animations: {
                    self.sendButton.snp.updateConstraints({ (make) in
                        make.right.equalToSuperview().offset(60)
                    })
                    self.layoutIfNeeded()
                })
            } else if sendButtonStatus == .blue {
                sendButton.setBackgroundImage(UIImage(named: "u_message_add"), for: .normal)
                sendButton.setBackgroundImage(UIImage(named: "u_message_addHL"), for: .highlighted)
                sendButton.setTitleColor(UIColor.white, for: .normal)
            } else if sendButtonStatus == .gray {
                sendButton.setBackgroundImage(UIImage(named: "u_message_add"), for: .normal)
                sendButton.setBackgroundImage(UIImage(named: "u_message_addHL"), for: .highlighted)
                sendButton.setTitleColor(UIColor.gray, for: .normal)
            }
        }
    }
    var emojiGroupData: [[TLEmojiGroup]] = [] {
        didSet {
            collectionView.reloadData()
            if emojiGroupData.count > 0 {
                self.curIndexPath = IndexPath(row: 0, section: 0)
            }
        }
    }
    weak var delegate: TLEmojiGroupControlDelegate?
    private var curIndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            collectionView.selectItem(at: curIndexPath, animated: false, scrollPosition: [])
            let group = (emojiGroupData[curIndexPath.section])[curIndexPath.row] as TLEmojiGroup
            delegate?.emojiGroupControl(self, didSelectedGroup: group)
        }
    }
    private lazy var collectionView: UICollectionView =  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        return collectionView
    }()

    private var addButton = UIButton()
    private var sendButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addButton.setImage(UIImage(named: "u_message_add"), for: .normal)
        addButton.addTarget(self, action: #selector(self.emojiAddButtonDown), for: .touchUpInside)
        addSubview(addButton)
        addSubview(collectionView)
        addSubview(sendButton)
        collectionView.register(TLEmojiGroupCell.self, forCellWithReuseIdentifier: TLEmojiGroupCell.identifier)
        addButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(46)
        }
        sendButton.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(60)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.addButton.snp.right)
            make.right.equalTo(self.sendButton.snp.left)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiGroupData.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (emojiGroupData[section] as [Any]).count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(TLEmojiGroupCell.self, for: indexPath)
        let group = emojiGroupData[indexPath.section][indexPath.row] as TLEmojiGroup
        cell.emojiGroup = group
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 46, height: frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == emojiGroupData.count - 1 {
            return CGSize(width: 46 * 2, height: frame.size.height)
        }
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = emojiGroupData[indexPath.section][indexPath.row] as TLEmojiGroup
        if group.type == .other {
            //: 存在冲突：用户选中cellA,再此方法中立马调用方法选中cellB时，所有cell都不会被选中
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.curIndexPath = self.curIndexPath
            })
            delegate?.emojiGroupControlEditMyEmojiButtonDown(self)
        } else {
            self.curIndexPath = indexPath
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 46, y: 5))
        context.addLine(to: CGPoint(x: 46, y: frame.size.height - 5))
        context.strokePath()
    }
    @objc func emojiAddButtonDown() {
        delegate?.emojiGroupControlEditButtonDown(self)
    }
    @objc func sendButtonDown() {
        delegate?.emojiGroupControlSendButtonDown(self)
    }
}
