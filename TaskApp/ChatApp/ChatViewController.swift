//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Teacher on 2016/05/21.
//  Copyright © 2016年 AKYLab. All rights reserved.
//

import UIKit
import SwiftWebSocket

class ChatViewController: UIViewController {
    // WebSocketクラスのインスタンス
    let webSocket = WebSocket()
    
    // チャットメッセージ表示テーブル
    @IBOutlet weak var tableView: UITableView!
    
    // テキスト入力
    @IBOutlet weak var textField: UITextField!
    
    // 送信ボタン
    @IBOutlet weak var sendButton: UIButton!
    
    // 送信ボタンタップ時イベント
    @IBAction func didTapSendButton(sender: UIButton) {
        // A ?? B => Aの値が存在すればその値をそのまま、存在しない(=nil)場合は、Bの値を使う
        // イメージ: A.exist ? A : B
        let message = textField.text ?? ""
        messageList.append(message)
        
        // テーブルをリロードする
        tableView.reloadData()
        
        // テーブルの表示位置を更新
        
        // テーブルに表示されている行数を取得
        let rowCount = tableView.numberOfRowsInSection(0) // セクションは1個固定なので0指定で良い
        // 表示される行数 = メッセージの数なので以下でもOK
        // let rowCount = messageList.count
        
        // 一番下のセル位置
        let indexPath = NSIndexPath(forRow: rowCount - 1, inSection: 0)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        
        // メッセージ入力欄をクリアする
        textField.text = ""
    }
    
    // チャットに表示されるメッセージリスト
    var messageList = [String]()
    // 下の書き方でもOK
    // var messageList: [String] = []
    
    // 画面読み込み時に呼ばれる (基本的には1回のみ)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webSocket.event.open = {
            // 通信接続完了時の処理
            print("connection opened.")
            
        }
        
        webSocket.event.close = { code, reason, clean in
            // 通信切断後の処理
            print("connection closed")
        }
        
        webSocket.event.error = { err in
            // 通信エラー時の処理
            print(err)
        }
        
        webSocket.event.message = { msg in
            // メッセージ受信時の処理
            let message = msg as! String
            self.messageList.append(message)
            self.tableView.reloadData()
        }
        
        webSocket.open("ws://172.19.72.103:8080")
    }
}

// DataSourceの中身を定義するために、UITableViewDataSourceに適合させる
extension ChatViewController: UITableViewDataSource {
    
    // テーブルのセクション毎の行数を定義
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    // セル毎のオブジェクトを返す
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "chatCell")
        
        // 何番目のセルかはindexPathから取得できる
        let num = indexPath.row
        cell.textLabel?.text = messageList[num]
        
        return cell
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // TextFieldの内容が変わった際の処理
        
        // 変更後の文字列が空かどうか判定(簡易版)
        let isEmpty = string.isEmpty && textField.text!.characters.count == 1
        
        // 中身が空になる時は、送信ボタンを押せないようにする
        sendButton.enabled = !isEmpty
        
        return true
    }
}