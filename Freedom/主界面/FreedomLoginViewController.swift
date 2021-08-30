//
//  FreedomLoginViewController.swift
//  Freedom
import UIKit
//import XCarryOn
//import XExtension
import AFNetworking
import RxSwift
import RxCocoa
enum LoginType {
    case login
    case regist
    case findPWD
}
class FreedomLoginViewController: BaseViewController {
    let user = User.shared
    var vcType = LoginType.login
    var countTimer: Timer?
    private var seconds = 0
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var verityButton: UIButton!
    @IBOutlet weak var userNameT: UITextField!
    @IBOutlet weak var passWordT: UITextField!
    @IBOutlet weak var phoneT: UITextField!
    @IBOutlet weak var verityCodeT: UITextField!
    public class func loginVCWith(type: LoginType) -> FreedomLoginViewController {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "LoginVC") as? FreedomLoginViewController
        vc?.vcType = type
        return vc ?? FreedomLoginViewController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        switch vcType {
        case .login:initLoginViewController()
        case .regist:initRegisterViewController()
        default:initFindPswViewController()
        }
    }

    ///登录控制器
    private func initLoginViewController() {
        actionButton.setTitle("登录", for: .normal)
        leftButton.setTitle("新用户", for: .normal)
        rightButton.setTitle("找回密码", for: .normal)
        leftButton.rx.tap.subscribe(onNext: { (sender) in
            self.gotoRegisterVC()
        }).disposed(by: disposeBag)
        rightButton.rx.tap.subscribe(onNext: { (sender) in
            self.gotoFindPswVC()
        }).disposed(by: disposeBag)
        actionButton.rx.tap.subscribe(onNext: { (sender) in
            self.loginAction()
        }).disposed(by: disposeBag)
    }
    ///注册控制器
    private func initRegisterViewController() {
        actionButton.setTitle("注册", for: .normal)
        leftButton.setTitle("登录", for: .normal)
        rightButton.setTitle("找回密码", for: .normal)
        leftButton.rx.tap.subscribe(onNext: { (sender) in
            self.gotoLoginVC()
        }).disposed(by: disposeBag)
        rightButton.rx.tap.subscribe(onNext: { (sender) in
            self.gotoFindPswVC()
        }).disposed(by: disposeBag)
        actionButton.rx.tap.subscribe(onNext: { (sender) in
            self.registerAction()
        }).disposed(by: disposeBag)
    }
    ///找回密码控制器
    private func initFindPswViewController() {
        actionButton.setTitle("修改密码", for: .normal)
        leftButton.setTitle("登录", for: .normal)
        rightButton.setTitle("注册", for: .normal)
        leftButton.rx.tap.subscribe(onNext: { (sender) in
            self.gotoLoginVC()
        }).disposed(by: disposeBag)
        rightButton.rx.tap.subscribe(onNext: { (sender) in
            self.gotoRegisterVC()
        }).disposed(by: disposeBag)
        actionButton.rx.tap.subscribe(onNext: { (sender) in
            self.findPwdBackAction()
        }).disposed(by: disposeBag)
    }

    func gotoRegisterVC() {
        let vc = FreedomLoginViewController.loginVCWith(type: .regist)
        navigationController?.pushViewController(vc, animated: true)
    }
    func gotoFindPswVC() {
        let vc = FreedomLoginViewController.loginVCWith(type: .findPWD)
        navigationController?.pushViewController(vc, animated: true)
    }
    func gotoLoginVC(){
        let loginVC = FreedomLoginViewController.loginVCWith(type: .login)
        let transition = CATransition()
        transition.type = CATransitionType.push//可更改为其他方式
        transition.subtype = CATransitionSubtype.fromLeft//可更改为其他方式
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(loginVC, animated: false)
    }
    func registerAction() {
        if !checkContent() {
            return
        }
        AFHttpTool.verifyVerificationCode("86", phoneNumber: user.phone, verificationCode: verityCodeT.text, success: { response in
            let response = response as! [String: Any]
            let code = response["code"] as! Int
            if code == 200 {
                let verificationToken = (response["result"] as! [String: Any])["verification_token"] as! String
                //注册用户
                AFHttpTool.register(withNickname: self.user.name, password: self.user.pwd, verficationToken: verificationToken, success: { responseDict in
                    let code = (responseDict as! [String: Any])["code"] as! Int
                    if code == 200 {
                        print("注册成功")
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 * Double(NSEC_PER_MSEC) / Double(NSEC_PER_SEC), execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }, failure: { err in
                    print("注册失败")
                })
            }
            if code == 1000 { print("验证码错误") }
            if code == 2000 { print("验证码过期") }
        }, failure: { err in
            print("验证码无效")
        })
    }
    func findPwdBackAction(){
        if !checkContent() {
            return
        }
        AFHttpTool.verifyVerificationCode("86", phoneNumber: user.phone, verificationCode: verityCodeT.text, success: { responseDict in
            let response = responseDict as! [String: Any]
            if (response["code"] as! Int) == 200 {
                let vToken = (response["result"] as! [String: Any])["verification_token"] as! String
                AFHttpTool.resetPassword(self.user.pwd, vToken: vToken, success: { resDict in
                    let res = resDict as! [String: Any]
                    if (res["code"] as! Int) == 200 {
                        print("修改成功!")
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5 * Double(NSEC_PER_MSEC) / Double(NSEC_PER_SEC), execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }, failure: { err in
                })
            }
        }, failure: { err in
        })
    }
    func loginAction() {
        if !checkContent(){
            return
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 60) {
            if self.user.status != 0 {
                
            }
        }
        XHud.show(.withDetail(message: "登录中..."))
        UserDefaults.standard.removeObject(forKey: "UserCookies")
        AFHttpTool.login(withPhone:user.name, password: user.pwd, region: "86", success: { responseDict in
            XHud.hide()
            let response = responseDict as! [String: Any]
            let code = response["code"] as! Int
            if code == 200 {
                let result = response["result"] as! [String: String]
                let token = result["token"] ?? ""
                let userId = result["id"] ?? ""
                self.user.token = token
                self.user.Id = userId
                self.loginRongCloud(self.user.name, userId: userId, token: token, password: self.user.pwd)
            } else {
                print("NSError is \(code)")
                if code == 1000 {
                    self.noticeError("手机号或密码错误！")
                }
                self.passWordT.shakeAnimation()
            }
        }, failure: { err in
            self.noticeError("登录失败，请检查网络。")
        })
    }
    //FIXME:用文件服务器配置登录,设置导航服务器和上传文件服务器信息
    func loginWithFileServer(_ appKey:String,_ demoServer:String,_ naviServer:String,_ fileServer:String) {
        navigationController?.pushViewController(FreedomLoginViewController.loginVCWith(type: .login), animated: true)
    }

    @IBAction func verityAction(_ sender: UIButton) {
        seconds = 60
        sender.isUserInteractionEnabled = false
        countTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timeFireMethod), userInfo: nil, repeats: true)
        AFHttpTool.checkPhoneNumberAvailable("86", phoneNumber: user.phone, success: { responseDict in
            let response = responseDict as! [String: Any]
                if (response["code"] as! Int) == 200 {
                    let resultStatus = response["result"] as! Int
                    if  resultStatus == 0 && self.vcType == .regist{
                        print("手机号已被注册")
                        return
                    }else if resultStatus != 0 && self.vcType != .regist {
                        print("手机号未被注册")
                        return
                    }
                    AFHttpTool.getVerificationCode("86", phoneNumber: self.user.phone, success: { resDict in
                        print(resDict ?? "")
                    }, failure: { err in
                        print("\(err!)")
                    })
                }
        }, failure: { err in
            print("\(err!)")
        })
    }
    @objc func timeFireMethod() {
        seconds -= 1
        let btnTitle = "\(seconds)秒后发送"
        verityButton.setTitle(btnTitle, for: .normal)
        if seconds == 0 {
            verityButton.isUserInteractionEnabled = true
            countTimer?.invalidate()
            verityButton.setTitle("获取验证码", for: .normal)
        }
    }
    private func checkContent() -> Bool{
        return true
    }

    //FIXME: 登录融云服务器
    private func loginRongCloud(_ userName: String, userId: String, token: String, password: String) {
        
    }
    private func loginSuccess() {
        user.status = 0
        let defaults = UserDefaults.standard
        defaults.set(user.toDict(), forKey: "user")
        defaults.set(user.name, forKey: "userName")
        defaults.set(user.pwd, forKey: "userPwd")
        defaults.set(user.Id, forKey: "userId")
        defaults.set(user.token, forKey: "userToken")
        defaults.synchronize()
        AFHttpTool.getUserInfo(user.Id, success: { response in
            let response = response as! [String: Any]
            let code = response["code"] as! Int
            if code == 200 {
                let result = response["result"] as! [String: String]
                let nickname = result["nickname"] ?? ""
                let portraitUri = result["portraitUri"] ?? ""
            }
        }, failure: { err in
        })
        //同步群组
        DispatchQueue.main.async(execute: {
            let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc: UIViewController? = StoryBoard.instantiateViewController(withIdentifier: "FirstViewController")
            let window:UIWindow = ((UIApplication.shared.delegate?.window)!)!
            window.rootViewController = vc!
        })
    }
}

extension FreedomLoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case userNameT:user.name = textField.text ?? ""
        case passWordT:user.pwd = textField.text ?? ""
        case phoneT:user.phone = textField.text ?? ""
        default:break
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == userNameT{
            passWordT.text = nil
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
