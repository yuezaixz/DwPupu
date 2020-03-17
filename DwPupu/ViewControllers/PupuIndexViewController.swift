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
import Unbox

class PupuIndexViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    private var headerView: IndexHeaderView!
    private let disposeBag = DisposeBag()
    
    // MARK: - live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.setupMainTableView()
        
        self.setupHeaderView()
        
        PupuApi.banners()
            .map { bannerJsonObjects in
                let filterObjects = bannerJsonObjects.filter({ bannerJsonObject -> Bool in
                    return bannerJsonObject["img_url"] != nil && !(bannerJsonObject["img_url"] is NSNull)
                })
                return (try? unbox(dictionaries: filterObjects, allowInvalidElements: true) as [Banner]) ?? []
            }.subscribe(onNext: { banners in
                print(banners)
            }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        mainTableView.removePullToRefresh(at: .top)
    }
    
    // MARK: - private view setup
    
    private func setupMainTableView() {
        self.mainTableView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height*2)
        var refresherHeight:CGFloat = 40
        if DeviceUtil.isFullScreen {
            refresherHeight = 84
        }
        let refresher = PullToRefresh(height: refresherHeight, position: .top)
        self.mainTableView.addPullToRefresh(refresher) {
            // action to be performed (pull data from some source)
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
                DispatchQueue.main.async {
                    self?.mainTableView.endRefreshing(at: .top)
                }
            }
        }
        self.mainTableView.contentInsetAdjustmentBehavior = .never
        
        let testView = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height*2))
        self.mainTableView.tableFooterView = testView
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = testView.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [UIColor.yellow, UIColor.red]
        testView.layer.addSublayer(gradientLayer)
        
        let testLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 20, height: 500))
        testLabel.numberOfLines = 0
        testLabel.text = "12kksdlfassfjaskljnklvmklasmdfasjdklfjawkl;ejfklasdnmvklsadjfklajsdklfjasdkl;fjklasmcklasdjflkasjdfkljslf"
        testView.addSubview(testLabel)
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
        let contentOffsetY = self.mainTableView.rx.contentOffset.map({$0.y}).share(replay: 1)
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

}
