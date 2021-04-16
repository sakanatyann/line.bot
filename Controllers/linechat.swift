//
//  linechat.swift
//  line.bot
//
//  Created by 酒井駿斗 on 2021/04/06.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class linechat: UIViewController {
    
    private let cellId = "cellId"
   // private var user: User?{
     //   didSet{
       //     navigationItem.title = user?.username
        //}
  //  }
    
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchLoginUserInfo()
    
    }

    private func setupViews(){
        
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
       
        navigationController?.navigationBar.barTintColor = .rgb(red: 39, green: 49, blue: 49)
        
        navigationItem.title =  "トーク"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white]
        
     
    
        let rightBarButton = UIBarButtonItem(title: "新規チャット", style: .plain, target: self, action: #selector(tappedNavRightBarButton))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        
    }
    
   
    
    @objc private func tappedNavRightBarButton(){
        let storyboard = UIStoryboard.init(name: "UserList", bundle: nil)
        let userListViewController = storyboard.instantiateViewController(withIdentifier: "UserListViewController")
        let nav = UINavigationController(rootViewController: userListViewController)
       self.present(nav, animated: true, completion: nil)
        
    }
    
    private func fetchLoginUserInfo(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("users").document(uid).getDocument{(snapshot, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
                return
            }
            
            guard let snapshot = snapshot,let dic = snapshot.data() else{return}
            
    
            
            let user = User(dic: dic)
            //self.user = user
            
        }
    }
   
}

extension linechat: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatlistTableViewcell
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped table view")
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController")
        navigationController?.pushViewController(chatRoomViewController, animated: true)
        
    }
    
                    
    }
class ChatlistTableViewcell: UITableViewCell {
    
    var user: User?{
        didSet{
            if let user = user{
            partnerLabel.text = user.username
            
           // userImageView.image = user?.profileImageUrl
            dataLabel.text = dateFormatterForDateLabel(date: user.createdAt.dateValue())
            latestMessageLabel.text = user.email
            }
            
        }
    }
    
    
 
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var latestMessageLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 35
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func dateFormatterForDateLabel(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
        
        
    }
}
