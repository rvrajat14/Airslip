//
//  WebViewController.swift
//  Airslip
//
//  Created by Rahul Verma on 19/02/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController , WKNavigationDelegate {
    @IBOutlet weak var webV: WKWebView!
    @IBOutlet weak var crossButton: UIButton!
    
    var googleAuthUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleAuthUrl = IDENTITY_BASE_URL + "/v1/identity/google-login"
        print(googleAuthUrl)
        let url = URL(string: googleAuthUrl)!
        webV.load(URLRequest(url: url))
        webV.allowsBackForwardNavigationGestures = true
     
        webV?.navigationDelegate = self
    }

    @IBAction func crossButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
     
             guard let url = navigationAction.request.url else { return }
             print("decidePolicyFor - url: \(url)")
        return
     
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
             print("didStartProvisionalNavigation - webView.url: \(String(describing: webView.url?.description))")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
             let nserror = error as NSError
             if nserror.code != NSURLErrorCancelled {
                 webV.loadHTMLString("Page Not Found", baseURL: URL(string: googleAuthUrl))
             }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
             print("didFinish - webView.url: \(String(describing: webV.url?.description))")
    }
    
}
