//
//  SwitchingViewController.swift
//  ViewSwitcher
//
//  Created by wanghuiyong on 19/01/2017.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import UIKit

// 自定义的 UIViewController 的子类作为根控制器
class SwitchingViewController: UIViewController {
    // 创建两个视图控制器属性
    private var blueViewController: BlueViewController!
    private var yellowViewController: YellowViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 视图加载完成后, 选择一个视图进行显示, 这里选择 blueViewController
        blueViewController = storyboard?.instantiateViewController(withIdentifier: "Blue") as! BlueViewController	// storyboard ID
        blueViewController.view.frame = view.frame
        switchViewController(from: nil, to: blueViewController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        if blueViewController != nil && blueViewController.view.superview == nil {
            blueViewController = nil
        }
        if yellowViewController != nil && yellowViewController.view.superview == nil {
            yellowViewController = nil
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // 根视图控制器中的工具栏触发的操作方法
    @IBAction func switchViews(sender: UIBarButtonItem) {
        // 创建视图控制器, 从 storyboard 中创建, 需要时创建, 节省内存, 如果一个已经存在, 就创建另一个, 因此在此之前至少存在一个
        if yellowViewController?.view.superview == nil {
            if yellowViewController == nil {
                yellowViewController = storyboard?.instantiateViewController(withIdentifier: "Yellow") as! YellowViewController
            }
        } else if blueViewController?.view.superview == nil {
            if blueViewController == nil {
                blueViewController = storyboard?.instantiateViewController(withIdentifier: "Blue") as! BlueViewController
            }
        }
        // 转场动画
        UIView.beginAnimations("View Flip", context: nil)	// 声明动画块
        UIView.setAnimationDuration(0.4)						// 动画持续时间
        UIView.setAnimationCurve(.easeInOut)					// 动画曲线
        
        // 切换视图控制器, 如果一个已经存在, 就切换到另一个
        if blueViewController != nil && blueViewController!.view.superview != nil {
            UIView.setAnimationTransition(.flipFromRight, for: self.view, cache: true)
            yellowViewController.view.frame = view.frame
            switchViewController(from: blueViewController, to: yellowViewController)
        } else {
            UIView.setAnimationTransition(.flipFromLeft, for: self.view, cache: true)
            blueViewController.view.frame = view.frame
            switchViewController(from: yellowViewController, to: blueViewController)
        }
        // 提交转场动画
        UIView.commitAnimations()
    }
    
    // 切换视图控制器
    private func switchViewController(from fromVC: UIViewController?, to toVC: UIViewController?) {
        if fromVC != nil {
            fromVC!.willMove(toParentViewController: nil)
            fromVC!.view.removeFromSuperview()
            fromVC!.removeFromParentViewController()
        }
        if toVC != nil {
            self.addChildViewController(toVC!)
            self.view.insertSubview(toVC!.view, at: 0)
            toVC!.didMove(toParentViewController: self)
        }
    }
}
