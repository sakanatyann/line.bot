//
//  UserListViewController.swift
//  line.bot
//
//  Created by 酒井駿斗 on 2021/04/14.
//

import UIKit
import Firebase
import FirebaseFirestore
import Nuke
import FirebaseAuth

class UserListViewController: UIViewController {
    
    private let cellId = "cellId"
    private var users = [User]()
    private var selectedUser: User?
    
    @IBOutlet weak var startChatButton: UIButton!
    

    @IBOutlet weak var userListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userListTableView.delegate = self
        userListTableView.dataSource = self
        startChatButton.layer.cornerRadius = 15
        startChatButton.isEnabled = false
        startChatButton.addTarget(self, action: #selector(tappedStartChatButton), for: .touchUpInside)
        
        navigationController?.navigationBar.barTintColor = .rgb(red: 39, green: 49, blue: 69)
        
        fetchUserInfoFromFirestore()
        
    }
    
    @objc func tappedStartChatButton(){
        print("tappedStartChatButton")
        
    }
    
    private func fetchUserInfoFromFirestore(){
        
        
        Firestore.firestore().collection("users").getDocuments{(snapshot,err)in
            if let err = err {
                print("user情報の取得に失敗しました。\(err)")
                return
             
        }
        
            snapshot?.documents.forEach({(snapshot) in
                let dic = snapshot.data()
                let user = User.init(dic: dic)
                
                guard let uid = Auth.auth().currentUser?.uid else{return}
                
                if uid == snapshot.documentID{
                    return
                    
                }
                
                self.users.append(user)
                self.userListTableView.reloadData()
                
                
                    //print("data:",data)
                
            })
        }
    }
}

extension UserListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserListTableViewCell
        cell.user = users[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startChatButton.isEnabled = true
        let user = users[indexPath.row]
        self.selectedUser = user
    }
    
}

class UserListTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet{
            usernameLabel.text = user?.username
            if let url = URL(string: user?.profileImageUrl ?? ""){
                Nuke.loadImage(with: url, into: userImageView)
            }
        }
        
    }
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 25
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    
}
