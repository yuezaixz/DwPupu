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

class PupuIndexViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var bannerInHomeView: UIView!
    @IBOutlet weak var bannerTopView: UIView!
    @IBOutlet weak var bannerContainerView: UIView!
    @IBOutlet weak var bannerInHomeHeight: NSLayoutConstraint!
    
    private var headerView: IndexHeaderView!
    private let disposeBag = DisposeBag()
    fileprivate var viewModel: IndexViewModel!
    
    // MARK: - live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = IndexViewModel()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.setupMainTableView()
        
        self.setupHeaderView()
        
        self.setupBannerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        mainScrollView.removePullToRefresh(at: .top)
    }
    
    // MARK: - private view setup
    
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
        
        let testLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 20, height: 500))
        testLabel.numberOfLines = 0
        testLabel.text = "12kksdlfassfjaskljnklvmklasmdfasjdklfjawkl;ejfklasdnmvklsadjfklajsdklfjasdkl;fjklasmcklasdjflkasjdfkljslf"
        scrollContainerView.addSubview(testLabel)
    }
    
    private func setupHeaderView() {
        headerView = Bundle.main.loadNibNamed("IndexHeaderView", owner: nil, options: nil)?[0] as? IndexHeaderView
        self.view.addSubview(headerView)
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
        
        viewModel.banners
            .filter({  $0.count > 0 })
            .map({ banners in
                return banners.filter{$0.bgColor.count > 0}.map{$0.imgUrl}
            }).subscribe(onNext: { [weak self] images in
                guard let self = self else { return }
                self.bannerContainerView.subviews.forEach({ view in
                    view.removeFromSuperview()
                })
                let screenWidth = self.bannerContainerView.bounds.width
                let imageHeight = 0.765124555*screenWidth
                let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0, y: 192-imageHeight, width: screenWidth, height:imageHeight))

                //设置滚动时间间隔 默认2.0s
                autoScrollView.glt_timeInterval = 4
                        
                //设置轮播图的方向 默认水平
                autoScrollView.scrollDirection = .horizontal

                //加载网络图片传入图片url数组， 加载本地图片传入图片名称数组
                autoScrollView.images = Array(images[0..<8])
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
                autoScrollView.didSelectItemHandle = {
                    print("autoScrollView1 点击了第 \($0) 个索引")
                }

                //自动滚动到当前索引事件
                autoScrollView.autoDidSelectItemHandle = { index in
                    print("autoScrollView1 自动滚动到了第 \(index) 个索引")
                }

                //PageControl点击事件
                autoScrollView.pageControlDidSelectIndexHandle = { index in
                    print("autoScrollView1 pageControl点击了第 \(index) 个索引")
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

}
