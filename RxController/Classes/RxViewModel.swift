//
//  RxViewModel.swift
//  RxController
//
//  Created by Meng Li on 04/09/2019.
//  Copyright (c) 2019 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow

open class RxViewModel: NSObject, Stepper {
    
    public let steps = PublishRelay<Step>()
    public let disposeBag = DisposeBag()
    
    deinit {
        Log.debug("[DEINIT View Model] \(type(of: self))")
    }
    
}


open class RxChildViewModel: RxViewModel {
    
    
    
}
