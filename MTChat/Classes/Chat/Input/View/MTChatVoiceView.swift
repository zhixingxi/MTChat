//
//  MTChatVoiceView.swift
//  MTChat
//
//  Created by IT A on 2018/11/27.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit

/// 语音消息输入状态
class MTChatVoiceView: UIView {

    //MARK: - 懒加载
    lazy var vCenter: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return v
    }()
    
    lazy var lbNote: UILabel = {
        let noteL = UILabel()
        noteL.text = "松开手指，取消发送"
        noteL.font = UIFont.systemFont(ofSize: 14.0)
        noteL.textColor = UIColor.white
        noteL.textAlignment = .center
        noteL.layer.cornerRadius = 2
        noteL.layer.masksToBounds = true
        return noteL
    }()
    
    lazy var ivCancel: UIImageView = {
        let cancelImgV = UIImageView(image: #imageLiteral(resourceName: "RecordCancel"))
        return cancelImgV
    }()
    
    lazy var ivTooShort: UIImageView = {
        let tooShortImgV = UIImageView(image: #imageLiteral(resourceName: "MessageTooShort"))
        return tooShortImgV
    }()
    
    lazy var vRecording: UIView = {
        let recordingV = UIView()
        return recordingV
    }()

    lazy var ivRecordingBG: UIImageView = {
        let recordingBkg = UIImageView(image: #imageLiteral(resourceName: "RecordingBkg"))
        recordingBkg.layer.cornerRadius = 5
        recordingBkg.layer.masksToBounds = true
        return recordingBkg
    }()
    var ivSignalValue: UIImageView = UIImageView(image: UIImage(named: "RecordingSignal008"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 对外提供的方法
extension MTChatVoiceView {
    // MARK: 正在录音
    func recording() {
        isHidden = false
        ivCancel.isHidden = true
        ivTooShort.isHidden = true
        vRecording.isHidden = false
        lbNote.backgroundColor = UIColor.clear
        lbNote.text = "手指上滑，取消发送"
    }
    
    // MARK: 滑动取消
    func slideToCancelRecord() {
        isHidden = false
        ivCancel.isHidden = false
        ivTooShort.isHidden = true
        vRecording.isHidden = true
        lbNote.backgroundColor = UIColor.hexInt(0x9C3638)
        lbNote.text = "松开手指，取消发送"
    }
    
    // MARK: 提示录音时间太短
    func messageTooShort() {
        isHidden = false
        ivCancel.isHidden = true
        ivTooShort.isHidden = false
        vRecording.isHidden = true
        lbNote.backgroundColor = UIColor.clear
        lbNote.text = "说话时间太短"
        // 0.5秒后消失
        let delayTime =  DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.endRecord()
        }
    }
    // MARK: 录音结束
    func endRecord() {
        self.isHidden = true
    }
    
    func updateMetersValue(_ value: Float) {
        var index = Int(String(value).first?.description ?? "0") ?? 0
        index = index > 7 ? 7 : index
        index = index < 0 ? 0 : index
        
        let array: [UIImage] = [
            UIImage(named: "RecordingSignal001")!,
            UIImage(named: "RecordingSignal002")!,
            UIImage(named: "RecordingSignal003")!,
            UIImage(named: "RecordingSignal004")!,
            UIImage(named: "RecordingSignal005")!,
            UIImage(named: "RecordingSignal006")!,
            UIImage(named: "RecordingSignal007")!,
            UIImage(named: "RecordingSignal008")!
        ]
        self.ivSignalValue.image = array[index]
        MTLog("更新音量 -- \(index)")
    }
}

// MARK: - UI
extension MTChatVoiceView {
    private func setupViews() {
        // 添加视图
        addSubview(vCenter)
        vCenter.addSubview(lbNote)
        vCenter.addSubview(ivCancel)
        vCenter.addSubview(ivTooShort)
        vCenter.addSubview(vRecording)
        vRecording.addSubview(ivRecordingBG)
        vRecording.addSubview(ivSignalValue)
        
        // 布局
        vCenter.snp.makeConstraints { (make) in
            make.width.height.equalTo(150)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        lbNote.snp.makeConstraints { (make) in
            make.left.equalTo(vCenter.snp.left).offset(8)
            make.right.equalTo(vCenter.snp.right).offset(-8)
            make.bottom.equalTo(vCenter.snp.bottom).offset(-6)
            make.height.equalTo(20)
        }
        ivCancel.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalTo(vCenter)
            make.top.equalTo(vCenter.snp.top).offset(14)
        }
        ivTooShort.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(ivCancel)
        }
        vRecording.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(ivCancel)
        }
        ivRecordingBG.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(vRecording)
            make.width.equalTo(62)
        }
        ivSignalValue.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(vRecording)
            make.left.equalTo(ivRecordingBG.snp.right)
        }
    }
}
