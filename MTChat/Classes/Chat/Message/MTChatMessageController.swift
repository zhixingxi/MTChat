//
//  MTChatMessageController.swift
//  MTChat
//
//  Created by IT A on 2018/11/27.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit

private let textCellId = "MTTextMessageCell"

protocol MTChatMessageControllerDelegate: NSObjectProtocol {
    func chatMsgVCWillBeginDragging(chatMsgVC: MTChatMessageController)
}

class MTChatMessageController: UIViewController {
    
    weak var delegate: MTChatMessageControllerDelegate?
    
    private var dataArray: [MTMessageProtocol] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MTChatColors.commonBgColor
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
            tb.backgroundColor = MTChatColors.commonBgColor
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.chatMsgVCWillBeginDragging(chatMsgVC: self)
    }
}

// MARK:- 对外提供的方法
extension MTChatMessageController {
    // MARK: 滚到底部
    func scrollToBottom(animated: Bool = false) {
        self.view.layoutIfNeeded()
        if dataArray.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 10 - 1, section: 0), at: .top, animated: animated)
        }
    }
    // MARK: 插入模型数据
    func insertRowModel(model: MTMessageProtocol, isBottom: Bool = true) {
        var indexPath: IndexPath!
        if isBottom {
            dataArray.append(model)
            indexPath = IndexPath(row: dataArray.count - 1, section: 0)
            _ = self.tableView(tableView, cellForRowAt: indexPath)
            self.insertRows([indexPath])
        } else {
            dataArray.insert(model, at: 0)
            indexPath = IndexPath(row: 0, section: 0)
            _ = self.tableView(tableView, cellForRowAt: indexPath)
            self.insertRows([indexPath], atBottom: false)
        }
    }
}

// MARK:- private Method
extension MTChatMessageController {
    // MARK: 插入数据
    private func insertRows(_ rows: [IndexPath], atBottom: Bool = true) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: rows, with: .none)
        self.tableView.endUpdates()
        if atBottom {
            self.scrollToBottom()
        }
        UIView.setAnimationsEnabled(true)
        MTLog("插入数据")
    }
    
    // MARK: 更新数据
    private func updataRow(_ rows: [IndexPath]) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: rows, with: .none)
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        MTLog("更新数据")
    }
    
    // MARK: 删除数据
    private func deleteRow(_ rows: [IndexPath]) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: rows, with: .none)
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        MTLog("删除数据")
    }
}

