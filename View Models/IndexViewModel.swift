//
//  IndexViewModel.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/17.
//  Copyright © 2020 davidandty. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm
import RxCocoa
import Unbox

class IndexViewModel {
    private let disposeBag = DisposeBag()
    
    let banners = BehaviorRelay<[Banner]>(value: [])
    
    init() {
      bindOutput()
    }

    func bindOutput() {

      PupuApi.banners()
          .map { bannerJsonObjects in
              let filterObjects = bannerJsonObjects.filter({ bannerJsonObject -> Bool in
                  return bannerJsonObject["img_url"] != nil && !(bannerJsonObject["img_url"] is NSNull)
              })
              return (try? unbox(dictionaries: filterObjects, allowInvalidElements: true) as [Banner]) ?? []
        }.bind(to: banners).disposed(by: disposeBag)
    }
}
