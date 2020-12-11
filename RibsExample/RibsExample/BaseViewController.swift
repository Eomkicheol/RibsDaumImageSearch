//
//  BaseViewController.swift
//  RibsExample
//
//  Created by Hanzo on 2020/11/30.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

class BaseViewController: UIViewController {

    // MARK: Properties

    var disposeBag = DisposeBag()

    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()

    private(set) var didSetupConstraints = false
    private(set) var didSetupSubViews = false


    private var scrollViewOriginalContentInsetAdjustmentBehaviorRawValue: Int?

    // MARK: UI Properties

    var convertSccenSize: CGFloat {
        return min(UIScreen.main.bounds.width, 375)
    }

    let networkIndicatorView = NetworkIndicatorView().then {
        $0.isHidden = true
        $0.isUserInteractionEnabled = false
    }

    // MARK: Initializing

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    deinit {
        #if DEBUG
        log.verbose("DEINIT: \(self.className)")
        #endif
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsUpdateConstraints()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.view.backgroundColor = .white

        self.configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //fix is 11 scroll view bug
        if let scrollView = self.view.subviews.first as? UIScrollView {
            self.scrollViewOriginalContentInsetAdjustmentBehaviorRawValue = scrollView.contentInsetAdjustmentBehavior.rawValue
            scrollView.contentInsetAdjustmentBehavior = .never
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let navi = self.navigationController, navi.viewControllers.first != self {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        } else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }

        if let scrollView = self.view.subviews.first as? UIScrollView,
           let rawValue = self.scrollViewOriginalContentInsetAdjustmentBehaviorRawValue,
           let behavior = UIScrollView.ContentInsetAdjustmentBehavior(rawValue: rawValue) {
            scrollView.contentInsetAdjustmentBehavior = behavior
        }
    }

    //뷰컨트롤의 뷰 제약조건을 업데이트 하기 위해 호출
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            //TODO -- 공통으로 필요한 것을 여기서 생성

            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()

    }

    //뷰컨트롤러의 뷰가 하위뷰를 표시했음을 알리기 위해 호출
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.didSetupSubViews {
            self.setupSubViews()
            self.didSetupSubViews = true
        }
    }

    // MARK: Func

    func configureUI() {
        [networkIndicatorView].forEach {
            self.view.addSubview($0)
        }
    }

    func setupConstraints() {
        networkIndicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }

    func setupSubViews() { }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

extension BaseViewController: UIGestureRecognizerDelegate { }

extension BaseViewController {
    func bottomTabBarHidden (_ checked: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.tabBarController?.tabBar.isHidden = checked
        }
    }
}

// MARK: - Reactive
extension Reactive where Base: BaseViewController {

    // Bindable sink for networking
    var networking: Binder<Bool> {
        return Binder(self.base) { viewController, isNetworking in
            viewController.view.bringSubviewToFront(viewController.networkIndicatorView)
            viewController.networkIndicatorView.isHidden = !isNetworking

        }
    }
}
