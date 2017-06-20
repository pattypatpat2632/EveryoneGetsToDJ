//
//  MultipeerManager.swift
//  EveryoneGetsToDJ
//
//  Created by Patrick O'Leary on 6/19/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import MultipeerConnectivity

final class MultipeerManager: NSObject {
    
    static let sharedInstance = MultipeerManager()
    let service = "everyonedj-3184"
    var availableJukeboxes = [Jukebox]() {
        didSet {
            delegate?.updateAvailablePeers()
        }
    }
    weak var delegate: MultipeerManagerDelegate?
    
    typealias jukeboxID = String
    
    var myPeerID = MCPeerID(displayName: FirebaseManager.sharedInstance.uid)
    
    var serviceAdvertiser: MCNearbyServiceAdvertiser?
    var serviceBrowser: MCNearbyServiceBrowser?
    
    lazy var session: MCSession = {
        
        let session = MCSession(peer: self.myPeerID, securityIdentity: nil, encryptionPreference: .optional)
        session.delegate = self
        return session
        
    }()
    
    private override init() {
        super.init()
    }
    
    deinit {
        serviceAdvertiser?.stopAdvertisingPeer()
        serviceBrowser?.stopBrowsingForPeers()
    }
    
    func startBroadcasting() {
        
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: service)
        serviceBrowser?.delegate = self
        serviceBrowser?.startBrowsingForPeers()
        
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: service)
        serviceAdvertiser?.delegate = self
        serviceAdvertiser?.startAdvertisingPeer()
        
    }
    
    func stopBroadcasting(completion: () -> Void){
        serviceBrowser?.stopBrowsingForPeers()
        serviceAdvertiser?.stopAdvertisingPeer()
        session.disconnect()
    }
    
}
//MARK: session functions
extension MultipeerManager {
    func send(method: MultipeerResource.Method) {
        if let jukebox = FirebaseManager.sharedInstance.jukebox {
            let json = MultipeerResource(method: method, jukebox: jukebox).asDictionary()
            if let data = try? JSONSerialization.data(withJSONObject: json, options: []) {
                do {
                    try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                }catch {
                    //TODO: error handling
                }
            }
        }
    }
    
    fileprivate func receive(data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []){
            if let resourceDict = json as? [String: Any] {
                let resource = MultipeerResource(dictionary: resourceDict)
                switch resource.method {
                case .send:
                    add(jukebox: resource.jukebox)
                case .remove:
                    remove(jukebox: resource.jukebox)
                }
            }
        }
    }
    
    fileprivate func remove(jukebox: Jukebox) {
        self.availableJukeboxes = availableJukeboxes.filter{$0.name != jukebox.name}
    }
    
    fileprivate func add(jukebox: Jukebox) {
        self.availableJukeboxes.append(jukebox)
    }
}

//MARK: Advertiser Delegate
extension MultipeerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if let context = context {
            receive(data: context)
        }
        invitationHandler(true, self.session)
    }
}

//MARK: Browser Delegate
extension MultipeerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if let jukebox = FirebaseManager.sharedInstance.jukebox {
            if let resource = MultipeerResource(method: .send, jukebox: jukebox).asData() {
                browser.invitePeer(peerID, to: self.session, withContext: resource, timeout: 30.0)
            }
        }
    }
}

extension MultipeerManager: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        receive(data: data)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("not connected")
        case .connecting:
            print("connecting")
        case .connected:
            print("connected")
        }
    }
    
    // Unused required delegate functions
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    }
    
}

protocol MultipeerManagerDelegate: class {
    func updateAvailablePeers()
}





