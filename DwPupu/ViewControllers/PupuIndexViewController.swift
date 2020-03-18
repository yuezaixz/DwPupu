//
//  PupuIndexViewController.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/16.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import SnapKit
import PullToRefresh
import RxSwift
import RxCocoa
import Kingfisher
import RxDataSources
import pop

class PupuIndexViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var bannerInHomeView: UIView!
    @IBOutlet weak var bannerTopView: UIView!
    @IBOutlet weak var bannerBgView: UIView!
    @IBOutlet weak var bannerContainerView: UIView!
    @IBOutlet weak var bannerInHomeHeight: NSLayoutConstraint!
    
    @IBOutlet var bannerTopViews: [UIView]!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryScrollContainerView: UIView!
    @IBOutlet weak var categoryMoreViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var newsContainer: UIView!
    
    
    private var headerView: IndexHeaderView!
    private let disposeBag = DisposeBag()
    fileprivate var viewModel: IndexViewModel!
    
    // MARK: - live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = IndexViewModel()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.setupBase()
        
        self.setupMainTableView()
        
        self.setupHeaderView()
        
        self.setupBannerView()
        
        self.setupCategoryView()
        
        self.setupNewsView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        mainScrollView.removePullToRefresh(at: .top)
    }
    
    // MARK: - private view setup
    
    private func setupBase() {
        
    }
    
    private func setupCategoryView() {
        self.categoryCollectionView.register(UINib(nibName: "HomeCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCategoryCollectionViewCell")
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: self.categoryCollectionView.bounds.width/5, height: 90.0)
        self.categoryCollectionView.setCollectionViewLayout(flowLayout, animated: false)
        
        self.viewModel.categories
            .filter{
                $0.count >= 8
            }
            .map { return Array($0[0..<8]) }
            .bind(to: self.categoryCollectionView.rx.items(cellIdentifier: "HomeCategoryCollectionViewCell")){ index, model, cell in
                guard let categoryCell = cell as? HomeCategoryCollectionViewCell else {return}
                categoryCell.nameLabel.text = model.name
                if model.imgUrl.count > 0 && model.imgUrl.range(of:"http") != nil {
                    categoryCell.categoryImageView.kf.setImage(with: URL(string:model.imgUrl))
                } else if model.imgUrl.count > 0 {
                    categoryCell.categoryImageView.kf.setImage(with: URL(string: "https://imgs.static.pupumall.com/".appending(model.imgUrl)))
                }
        }.disposed(by: disposeBag)
        
        let categoryScrollView = UIScrollView()
        categoryScrollView.showsHorizontalScrollIndicator = false
        categoryScrollView.showsVerticalScrollIndicator = false
        categoryScrollView.alwaysBounceVertical = false
        categoryScrollView.alwaysBounceHorizontal = false
        categoryScrollView.bounces = false
        self.categoryScrollContainerView.addSubview(categoryScrollView)
        categoryScrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        let categoryMoreViewNib = UINib(nibName: "HomeCategoryMoreView", bundle: nil)
        self.viewModel.categories
            .filter{$0.count >= 8}
            .subscribe(onNext: { categories in
                guard categories.count > 8 else {return}
                let elseCategories = Array(categories[8..<13])
                var lastView:UIView? = nil
                elseCategories.forEach { categoryItem in
                    guard let categoryMoreView = categoryMoreViewNib.instantiate(withOwner: nil, options: nil)[0] as? HomeCategoryMoreView else {return}
                    categoryScrollView.addSubview(categoryMoreView)
                    categoryMoreView.snp.makeConstraints { make in
                        make.height.equalTo(40)
                        make.centerY.equalToSuperview()
                    }
                    categoryMoreView.nameLabel.text = categoryItem.name
                    if categoryItem.imgUrl.count > 0 && categoryItem.imgUrl.range(of:"http") != nil {
                        categoryMoreView.categoryImageView.kf.setImage(with: URL(string:categoryItem.imgUrl))
                    } else if categoryItem.imgUrl.count > 0 {
                        categoryMoreView.categoryImageView.kf.setImage(with: URL(string: "https://imgs.static.pupumall.com/".appending(categoryItem.imgUrl)))
                    }
                    
                    if let lastView = lastView {
                        categoryMoreView.snp.makeConstraints { make in
                            make.left.equalTo(lastView.snp.right).offset(7)
                        }
                    } else {
                        categoryMoreView.snp.makeConstraints { make in
                            make.left.equalToSuperview().offset(20)
                        }
                    }
                    
                    lastView = categoryMoreView
                }
                
                if let moreView = categoryMoreViewNib.instantiate(withOwner: nil, options: nil)[0] as? HomeCategoryMoreView, let lastView = lastView {
                    categoryScrollView.addSubview(moreView)
                    moreView.backgroundColor = UIColor(hex: "#FFE092")
                    moreView.snp.makeConstraints { make in
                        make.left.equalTo(lastView.snp.right).offset(7)
                        make.right.equalToSuperview().offset(-20)
                        make.height.equalTo(40)
                        make.centerY.equalToSuperview()
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupMainTableView() {
        self.mainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height*2)
        var refresherHeight:CGFloat = 40
        if DeviceUtil.isFullScreen {
            refresherHeight = 84
        }
        let refresher = PullToRefresh(height: refresherHeight, position: .top)
        self.mainScrollView.addPullToRefresh(refresher) {
            // action to be performed (pull data from some source)
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
                DispatchQueue.main.async {
                    self?.mainScrollView.endRefreshing(at: .top)
                }
            }
        }
        self.mainScrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupHeaderView() {
        headerView = Bundle.main.loadNibNamed("IndexHeaderView", owner: nil, options: nil)?[0] as? IndexHeaderView
        self.view.addSubview(headerView)
        
        viewModel.title.asDriver(onErrorJustReturn: "").drive(headerView.searchBtn.rx.title(for: .normal)).disposed(by: disposeBag)
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            
            make.top.left.right.equalToSuperview()
            var height = 96
            if DeviceUtil.isFullScreen {
                height += 22
            }
            make.height.equalTo(height)
            
        }
        let contentOffsetY = self.mainScrollView.rx.contentOffset.map({$0.y}).share(replay: 1)
        contentOffsetY
            .filter({ y -> Bool in
                return y <= 0
            })
            .subscribe(onNext: {[weak self] y in
                guard let self = self else { return }
                self.headerView.transform = CGAffineTransform(translationX: 0, y: -y)
            }).disposed(by: disposeBag)
        let contentOffsetYLessThan40 = contentOffsetY.filter{$0 <= 40 && $0 >= 0}
        
        contentOffsetYLessThan40.subscribe(onNext: { [weak self] offset in
            self?.headerView.snp.updateConstraints { make in
                var height = 96
                if DeviceUtil.isFullScreen {
                    height += 22
                }
                height = height-Int(offset)
                make.height.equalTo(height)
            }
        }).disposed(by: disposeBag)
        
        let contentOffsetYDrive = contentOffsetYLessThan40.asDriver(onErrorJustReturn: 0)
        
        contentOffsetYDrive.drive(self.headerView.rx.offset).disposed(by: disposeBag)
    }
    
    private func setupBannerView() {
        if DeviceUtil.isFullScreen {
            bannerInHomeHeight.constant = 352
        }
        self.viewModel.topColor.subscribe(onNext: {[weak self] color in
            guard let self = self else { return }
            

            self.bannerTopViews.forEach { bannerTopView in
                bannerTopView.backgroundColor = color
            }
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bannerBgView.bounds
            gradientLayer.startPoint = CGPoint(x: 0,y: 0)
            gradientLayer.endPoint = CGPoint(x: 0,y: 1)
            //设置渐变的主颜色
            gradientLayer.colors = [color.cgColor, UIColor.white.cgColor]
            //将gradientLayer作为子layer添加到主layer上
            self.bannerBgView.layer.addSublayer(gradientLayer)

        }).disposed(by: disposeBag)
        
        viewModel.banners
            .filter({  $0.count > 0 })
            .map({ banners in
                return Array(banners.filter{$0.bgColor.count > 0}[0..<min(banners.count, 8)]).map{$0.imgUrl}
            }).subscribe(onNext: { [weak self] images in
                guard let self = self else { return }
                self.bannerContainerView.subviews.forEach({ view in
                    view.removeFromSuperview()
                })
                self.viewModel.bannerIndex.accept(0)
                let imageWidth = self.bannerContainerView.bounds.width
                let imageHeight = 0.765124555*imageWidth
                let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 192-imageHeight, width: imageWidth, height:imageHeight))

                //设置滚动时间间隔 默认2.0s
                autoScrollView.glt_timeInterval = 15.0
                        
                //设置轮播图的方向 默认水平
                autoScrollView.scrollDirection = .horizontal

                //加载网络图片传入图片url数组， 加载本地图片传入图片名称数组
                autoScrollView.images = images
        //
        //        //加载图片，内部不依赖任何图片加载框架
                autoScrollView.imageHandle = {(imageView, imageName) in
                    imageView.kf.setImage(with: URL(string: "https://imgs.static.pupumall.com/".appending(imageName)))
                }

                //设置pageControl View的高度 默认为20
                autoScrollView.gltPageControlHeight = 20;

                // 是否自动轮播 默认true
                autoScrollView.isAutoScroll = true

                //dot在轮播图的位置 中心 左侧 右侧 默认居中
                autoScrollView.dotDirection = .right

                //点击事件
                autoScrollView.didSelectItemHandle = {[weak self] in
                    print("autoScrollView1 点击了第 \($0) 个索引")
                    self?.viewModel.bannerIndex.accept($0)
                }

                //自动滚动到当前索引事件
                autoScrollView.autoDidSelectItemHandle = {[weak self]  index in
                    print("autoScrollView1 自动滚动到了第 \(index) 个索引")
                    self?.viewModel.bannerIndex.accept(index)
                }

                //PageControl点击事件
                autoScrollView.pageControlDidSelectIndexHandle = {[weak self]  index in
                    print("autoScrollView1 pageControl点击了第 \(index) 个索引")
                    self?.viewModel.bannerIndex.accept(index)
                }

                //dot在轮播图的位置 左侧 或 右侧时，距离最屏幕最左边或最最右边的距离，默认0
                autoScrollView.adjustValue = 15.0
                
                self.bannerContainerView.addSubview(autoScrollView)

                //设置LTDotLayout，更多dot使用见LTDotLayout属性说明
//                let layout = LTDotLayout(dotImage: dotImage, dotSelectImage: dotSelectImage)
//                layout.dotMargin = 10.0
//                autoScrollView.dotLayout = layout
            }).disposed(by: disposeBag)
        
        
    }
    
    private func setupNewsView() {
        let duration = 5.0
        let newsHeight = self.newsLabel.bounds.height*1.5
        self.newsContainer.layer.borderColor = UIColor(hex: "#FFEBD1").cgColor
        self.newsContainer.layer.borderWidth = 1.0
        
        if let animation = POPCustomAnimation(block: {[weak self] (target, animation) -> Bool in
            guard let self = self, let animation = animation else { return false }
                        
            var progress = (Double(animation.currentTime).truncatingRemainder(dividingBy: duration))/duration
            
            if progress >= 0.5 {
                self.newsLabel.text = "可配送时间：7:00 ~ 22:30 >"
                progress -= 0.5
            } else {
                self.newsLabel.text = "龙虾帝王蟹...高级海鲜售卖中 >"
            }
            
            if progress > 0.2 {
                progress = 0.2
            }
            
            progress *= 5
            
            self.newsLabel.transform = CGAffineTransform(translationX: 0, y: CGFloat(1-progress)*newsHeight)
            
            return true
        }) {
            self.newsLabel.pop_add(animation, forKey: "scroll_news")
        }
    }

}
