//
//  FirmwareUpdateDialogeViewController.swift
//  Aduro
//
//  Created by Macbook Pro on 20/10/2020.
//  Copyright © 2020 nbe. All rights reserved.
//

import UIKit

class FirmwareUpdateDialogeViewController: UIViewController {

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var buttontext: RoundButton!
    @IBOutlet weak var mainView: MyCustomView!
    var delegate : firmwaredelegate!
    var countDownTimermode1 : Timer!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.text=Language.getInstance().getlangauge(key: "update_title")
        mainText.text=Language.getInstance().getlangauge(key: "update_prompt_auto")
        buttontext.setTitle(Language.getInstance().getlangauge(key: "push_firmware"), for: .normal)
        
             let tapgestureFirst = UITapGestureRecognizer(target: self, action: #selector(self.FirstlayoutTap))
             mainView.addGestureRecognizer(tapgestureFirst)
//        let blurFx = UIBlurEffect(style: UIBlurEffect.Style.light)
//        let blurFxView = UIVisualEffectView(effect: blurFx)
//        blurFxView.frame = view.bounds
//        blurFxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.insertSubview(blurFxView, at: 0)
        // Do any additional setup after loading the view.
        var timelimit = 11
        countDownTimermode1 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
                                    { (Timer) in
        //                                print("counter 1 chal raha \(Timer)")
                                        if(timelimit > 0)
                                        {
                                            timelimit=timelimit-1
                                            var string = Language.getInstance().getlangauge(key: "update_prompt_auto")
                                            string = string.replacingOccurrences(of: "{{seconds}}", with: String(timelimit))
                                            self.mainText.text=string
                                        }else
                                        {
                                            self.delegate.donedialogStartFirmware()
                                            self.dismiss(animated: true)
                                        }
                                       
                                    }
                    RunLoop.current.add(countDownTimermode1, forMode: RunLoop.Mode.common)

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         if(countDownTimermode1 != nil)
                    {
                        countDownTimermode1!.invalidate()
                        countDownTimermode1=nil
                        print("stop timer")
                    }
    }
      @objc func FirstlayoutTap()  {
//        print("press on my view clicked")
        if(countDownTimermode1 != nil)
             {
                 countDownTimermode1!.invalidate()
                 countDownTimermode1=nil
                 print("stop timer")
             }
        dismiss(animated: true)
    }
    @IBAction func button(_ sender: Any) {
        delegate.donedialogStartFirmware()
        if(countDownTimermode1 != nil)
             {
                 countDownTimermode1!.invalidate()
                 countDownTimermode1=nil
                 print("stop timer")
             }
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol firmwaredelegate {
    func donedialogStartFirmware()
}
