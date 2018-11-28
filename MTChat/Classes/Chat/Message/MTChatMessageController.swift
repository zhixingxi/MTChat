//
//  MTChatMessageController.swift
//  MTChat
//
//  Created by IT A on 2018/11/27.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit

private let textCellId = "MTTextMessageCell"

class MTChatMessageController: UIViewController {
    
    private var dataArray: [MTMessageProtocol] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        setupTableView()
    }
    
    private var tableView: UITableView!
}

// MARK: - 初始化ui
extension MTChatMessageController {
    private func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .plain).then({ (tb) in
            tb.showsVerticalScrollIndicator = false
            tb.separatorStyle = .none
            tb.dataSource = self
            tb.delegate = self
            tb.tableFooterView = UIView()
            tb.register(MTTextMessageCell.self, forCellReuseIdentifier: textCellId)
            view.addSubview(tb)
            tb.snp.makeConstraints({ (m) in
                m.edges.equalToSuperview()
            })
        })
        
    }
}

extension MTChatMessageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = MTMessage()
        var cell: MTMessageBaseCell
        switch model.getMsgType() {
        case .text:
            cell = tableView.dequeueReusableCell(withIdentifier: textCellId, for: indexPath) as! MTTextMessageCell
        default:
            cell = MTMessageBaseCell()
        }
        cell.messageModel = model
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
}
