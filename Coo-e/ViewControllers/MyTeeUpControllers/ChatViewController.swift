//
//  ChatViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 09/01/17.
//  Copyright © 2017 Atisha Poojary. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import JSQMessagesViewController

final class ChatViewController: JSQMessagesViewController{



    //b4f6fabf-3406-40c1-a6dd-a1adc7b0627d should be replaced by teeupID currently hardcoded
    private lazy var messageRef: FIRDatabaseReference = FIRDatabase.database().reference().child("teeups").child("b4f6fabf-3406-40c1-a6dd-a1adc7b0627d").child("messages")
    private var newMessageRefHandle: FIRDatabaseHandle?
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var messages = [JSQMessage]()
    
    func formatTimestamp() -> String{
        let myFormatter = DateFormatter()
        let date = Date()
        let cal = Calendar.current
        let year = cal.component(.year,from:date)
        let month = cal.component(.month, from:date)
        let day = cal.component(.day, from:date)
        let hour = cal.component(.hour, from:date)
        let minute = cal.component(.minute, from:date)
        let second = cal.component(.second, from:date)
        var timeStampDateComponent = DateComponents()
        timeStampDateComponent.year = year
        timeStampDateComponent.month = month
        timeStampDateComponent.day = day
        timeStampDateComponent.hour = hour
        timeStampDateComponent.minute = minute
        timeStampDateComponent.second = second
        timeStampDateComponent.timeZone = TimeZone(identifier: "America/New_York")
        let stringifyDate = cal.date(from:timeStampDateComponent)!
        myFormatter.dateStyle = .medium
        myFormatter.timeStyle = .long
        let finalStringDate = myFormatter.string(from:stringifyDate)
        return finalStringDate
    }

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
    }
    
    func setUp(){
        self.senderId = FIRAuth.auth()?.currentUser?.uid
        self.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName ?? "HugeCock"
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        let senderDisplayName = message.senderDisplayName + "•" + self.formatTimestamp()
        return NSAttributedString(string: senderDisplayName)
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    private func observeMessages() {
        //messageRef = messageRef!.child("teeups").child("b4f6fabf-3406-40c1-a6dd-a1adc7b0627d").child("messages")
        // 1.
        let messageQuery = messageRef.queryLimited(toLast:25)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                // 4
                self.addMessage(withId: id, name: name, text: text)
                
                // 5
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })
    }
       override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        observeMessages()
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        self.navigationItem.title = "Conversation"
//        
//        NotificationCenter.default.addObserver(self, selector:#selector(ChatViewController.handleKeyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector:#selector(ChatViewController.handleKeyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            "timeStamp":self.formatTimestamp()
            ]
        
        itemRef.setValue(messageItem) // 3
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        
        finishSendingMessage() // 5
    }



    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
