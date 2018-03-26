//
//  MPCManager.swift
//  MPCRevisited
//
//  Created by Gabriel Theodoropoulos on 11/1/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import MultipeerConnectivity


protocol MPCManagerDelegate {
    func foundPeer()
    func lostPeer()
    func invitationWasReceived(_ fromPeer: String)
    func connectedWithPeer(_ peerID: MCPeerID)
}


class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    @available(iOS 7.0, *)
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        foundPeers.append(peerID)
        delegate?.foundPeer()
    }

    var delegate: MPCManagerDelegate?
    var session: MCSession!
    var peer: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    var foundPeers = [MCPeerID]()
    var invitationHandler: ((Bool, MCSession?)->Void)!
    
    
    var trozos: [String: [Data]] = [:]
    
    override init() {
        super.init()
        
        peer = MCPeerID(displayName: UIDevice.current.name)
        
        //session = MCSession(peer: peer)
        session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        session.delegate = self
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "appcoda-mpc")
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "appcoda-mpc")
        advertiser.delegate = self
    }
    
    func browser(_ browser: MCNearbyServiceBrowser?, lostPeer peerID: MCPeerID?) {
        delegate?.lostPeer()
        for (index, aPeer) in foundPeers.enumerated(){
            if aPeer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        print(error.localizedDescription)
    }
    
    
    // MARK: MCNearbyServiceAdvertiserDelegate method implementation
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: Data!, invitationHandler: ((Bool, MCSession?) -> Void)!) {
        self.invitationHandler = invitationHandler
        delegate?.invitationWasReceived(peerID.displayName)
    }
    
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
    }
    
    
    // MARK: MCSessionDelegate method implementation
    func session(_ session: MCSession!, peer peerID: MCPeerID!, didChange state: MCSessionState) {
        switch state{
        case MCSessionState.connected:
            print("Connected to session: \(session)")
            delegate?.connectedWithPeer(peerID)
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
        default:
            print("Did not connect to session: \(session)")
        }
    }
    
    
    func session(_ session: MCSession!, didReceive data: Data, fromPeer peerID: MCPeerID!) {
        let dictionary: [String: AnyObject] = ["data": data as AnyObject, "fromPeer": peerID]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "receivedMPCDataNotification"), object: dictionary)
    }
    
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("ESTOY EMPEZANDO A RECIBIR MENSAJE")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("TERMINÉ A RECIBIR MENSAJE")
    }
    
    func session(_ session: MCSession!, didReceive stream: InputStream, withName streamName: String!, fromPeer peerID: MCPeerID!) { }
    
    
    
    // MARK: Custom method implementation
    func sendData(dictionaryWithData dictionary: Dictionary<String, String>, toPeer targetPeer: MCPeerID) -> Bool {
        let dataToSend = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        let peersArray = NSArray(object: targetPeer)
        var error: NSError?
        var wat = true
        do {
            let algo = try session.send(dataToSend, toPeers: peersArray as! [MCPeerID], with: MCSessionSendDataMode.reliable)
        }catch{
            wat = false
        }
        if !wat {
            return false
        }
        return true
    }
    
    func sendData2(dictionaryWithData dictionary: Dictionary<String, [Mensaje]>, toPeer targetPeer: MCPeerID) -> Bool {
        let dataToSend = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        let peersArray = NSArray(object: targetPeer)
        var error: NSError?
        var wat = true
        do {
            let algo = try session.send(dataToSend, toPeers: peersArray as! [MCPeerID], with: MCSessionSendDataMode.reliable)
        }catch{
            wat = false
        }
        if !wat {
            return false
        }
        return true
    }
    
}
