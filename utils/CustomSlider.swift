//
//  CustomSlider.swift
//  Ezy-Capture
//
//  Created by Toqeer Ahmed on 1/23/20.
//  Copyright © 2020 Codes Orbit Pvt Ltd. All rights reserved.
//

import UIKit



protocol SliderDelegate: AnyObject {
    func getSliderValue (value: Float, sliderName: String)
}

class CustomSlider: UIView {

    //MARK: - Variables
    var view: UIView!
    var minValue: Int!
    var maxValue: Int!
    var interval: Int!
    private var sliderValueUpdated:((Int)->Void)?
    weak var delegate: SliderDelegate?
    var sliderName: String = Values.bbq_fixed_temperature
    
    //MARK: - IBOutlets
    @IBOutlet var rangeLabels: [UILabel]!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var thumbLabel: UILabel!
    @IBOutlet weak var thumbLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var thumbLabelImage: UIImageView!
    @IBOutlet weak var minRangeLabel: UILabel!
    @IBOutlet weak var rangeStackView: UIStackView!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    

    //MARK: - UIView Methods
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        xibSetup()
    }
    
    
    //MARK: - View Setup
    
    func xibSetup() {
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        slider.isUserInteractionEnabled = false
        addSubview(view)
        setupView()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: String(describing: type(of:self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
//    func setupTargetActions(){
//        slider.addTarget(self, action: #selector(onSliderValueChanged(slider:event:)), for: .valueChanged)
//    }
    
//    @objc func onSliderValueChanged(slider: UISlider, event: UIEvent){
//        updateView()
//        if let touchEvent = event.allTouches?.first {
//            switch touchEvent.phase {
//            case .ended:
//                delegate?.getSliderValue(value: slider.value, sliderName: sliderName)
//            default:
//                break
//            }
//        }
//    }
    
    func setThumbImage(_ image: UIImage?){
        slider.setThumbImage(image ?? UIImage(), for: .normal)
    }
    
    func setThumbLabelImage(_ image: UIImage){
        thumbLabelImage.image = image
    }
    
    func setThumbLabelColor(_ color: UIColor){
        thumbLabelImage.tintColor = color
    }
    
    func setThumbColor(_ color: UIColor){
        slider.thumbTintColor = color
    }
    
    func setTrackColor(_ color: UIColor){
        slider.tintColor = color
    }
    
    
    func setupView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(sliderTapped))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sliderTapped))
        self.view.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(tapGesture)
        showThumbLabel(false)
    }
    
    func showThumbLabel(_ flag:Bool){
        if flag {
            thumbLabel.isHidden = false
            thumbLabelImage.isHidden = false
        } else {
            thumbLabel.isHidden = true
            thumbLabelImage.isHidden = true
        }
    }
    
    //MARK: - IBActions
 
//
//    @IBAction func sliderValueChanged(_ sender: UISlider) {
//        updateView()
//    }
   
    //MARK: - Selectors
    
    @objc public func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
       showThumbLabel(true)
        let pointTapped: CGPoint = gestureRecognizer.location(in: self)
        let positionOfSlider: CGPoint = slider!.frame.origin
        let widthOfSlider: CGFloat = slider!.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(slider!.maximumValue) / widthOfSlider)
        let intervalValue = self.interval ?? 1
        let adjustedValue = Int(newValue / CGFloat(intervalValue)) * intervalValue
        slider!.setValue(Float(adjustedValue), animated: true)
        updateView()
        
        if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            showThumbLabel(false)
            delegate?.getSliderValue(value: slider.value, sliderName: sliderName)
        }
    }
    
    //MARK: - Methods
     
    // Range Labels are hidden on the Xib. To show them this function should be called
    func setRangeLabels(){
        rangeStackView.isHidden = false
        let interval = maxValue / 5
        var currentValue = interval
        
        rangeLabels.forEach { (label) in
            label.text = "\(Int(currentValue))"
            currentValue += interval
            label.textColor = UIColor(named: "textColorLight")
        }
        minRangeLabel.textColor = UIColor(named: "textColorLight")
    }
    
    
    func configureSlider(value: Int?, minValue: Int, maxValue:Int, interval:Int, onValueUpdate:((Int)->Void)? = nil) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.interval = interval
        sliderValueUpdated = onValueUpdate
        minLabel.text = "\(minValue)"
        maxLabel.text = "\(maxValue)"
        slider.maximumValue = Float(maxValue)
        slider.minimumValue = Float(minValue)
        slider.value = Float(value ?? minValue) 
        thumbLabel.text = "\(value ?? minValue)"
        view.backgroundColor = UIColor(named: "background")
        updateView()
    }
    
    func addGradientTrack() {
        superview?.layoutIfNeeded()
        let layer = CAGradientLayer()
        layer.cornerRadius = slider.bounds.height/2.0
        layer.frame = slider.trackRect(forBounds: slider.frame)
        layer.colors = [#colorLiteral(red: 0.4392156863, green: 0.6156862745, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.7568627451, green: 0.4784313725, blue: 0.9882352941, alpha: 1).cgColor]
        layer.endPoint = CGPoint(x: 1.0, y:  1.0)
        layer.startPoint = CGPoint(x: 0.0, y:  1.0)
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let layerImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        slider.setMinimumTrackImage(layerImage.resizableImage(withCapInsets: .zero, resizingMode: .tile), for: .normal)
    }
    
    //MARK: - Private Methods
    
    private func updateView() {
        thumbLabel.text = Int(slider.value) == 0 ? "OFF": "\(Int(slider.value))"
        let rect = slider.thumbRect(forBounds: slider.bounds, trackRect: slider.trackRect(forBounds: slider.bounds), value: slider.value)
        
        thumbLeadingConstraint.constant = rect.origin.x - (thumbLabelImage.frame.width / 2) + 23
        
//        if slider.value >= (slider.maximumValue / 5) * 4 {
//            print("slider.value.greater", slider.value)
// thumbLeadingConstraint.constant = rect.origin.x - (thumbLabelImage.frame.width / 2) + 13
//
//        } else {
//            print("slider.value.lesser", slider.value)
//
//            thumbLeadingConstraint.constant = rect.origin.x - (thumbLabelImage.frame.width / 2) + 13
//        }
        sliderValueUpdated?(Int(slider.value))
    }
    
    
}
