//
//  Wilhelm.swift
//  Re:ゼロから始める異世界生活
//
//  Created by LawLincoln on 2016/10/9.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

import UIKit

/// Wilhelm van Astrea
public final class Wilhelm {
    
    public struct ServerSideAppControl {
        internal let version: String
        internal let forceUpdate: Bool
        public init(version: String, forceUpdate: Bool) {
            self.version = version
            self.forceUpdate = forceUpdate
        }
    }
    
    private static var shared: Wilhelm! = Wilhelm()
    private static func happyEnd() { shared = nil }
    public enum ITCLanguage {
        case en, cn, custom(String)
        var raw: String {
            switch self {
            case .en: return "en"
            case .cn: return "cn"
            case .custom(let custom): return custom
            }
        }
    }
    private init() { }
    /// handle works
    ///
    /// - parameter bundleIdentifier: bundle id of querying app, such as com.abc.com
    /// - parameter extraInfo:        server side control info of app
    /// - parameter language:         language to show, default cn
    /// - parameter ignore:           custom ignore title
    /// - parameter update:           custom update title
    public static func handle(app bundleIdentifier: String, extraInfo: ServerSideAppControl? = nil, language: ITCLanguage = .cn, customIgnore ignore: String? = nil, customUpdate update: String? = nil) {
        Wilhelm.shared.handle(with: language, bundleIdentifier: bundleIdentifier, extraInfo: extraInfo, customIgnore: ignore, customUpdate: update)
    }
    
    fileprivate func handle(with language: ITCLanguage, bundleIdentifier id: String, extraInfo: ServerSideAppControl?, customIgnore ignore: String? = nil, customUpdate update: String? = nil) {
        let raw = "https://itunes.apple.com/lookup?bundleId=\(id)&country=\(language.raw)"
        guard let url = URL(string: raw) else { return }
        let task = URLSession.shared.dataTask(with: url) {[weak self] (data, _, _) in
            guard let d = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: d, options: .allowFragments)
                let forceUpdate = extraInfo?.forceUpdate ?? false
                if let dic = json as? [String : Any],
                    let results = dic["results"] as? [Any],
                    let first = results.first as? [String : Any],
                    let appStoreVersion = first["version"] as? String,
                    let localAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
                    let releaseNotes = first["releaseNotes"] as? String,
                    let url = first["trackViewUrl"] as? String,
                    let serverVersion = (extraInfo?.version) ?? (first["version"] as? String),
                    appStoreVersion > localAppVersion && serverVersion >= appStoreVersion  {
                    var updateTitle: String {
                        if let u = update { return u }
                        else if case ITCLanguage.en = language { return "Update Now" } else { return "现在升级" }
                    }
                    var ignoreTitle: String {
                        if let u = ignore { return u }
                        else if case ITCLanguage.en = language { return "Ignore" } else { return "忽略" }
                    }
                    self?.showTips(with: appStoreVersion, message: releaseNotes, forceUpdate: forceUpdate, url: url, ignore: ignoreTitle, update: updateTitle)
                }
            } catch {
                Wilhelm.happyEnd()
                print("❌[Wilhelm]:\(error)")
            }
        }
        task.resume()
    }
    
    private func showTips(with title: String, message msg: String, forceUpdate: Bool, url: String, ignore: String, update: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let updateAction = UIAlertAction(title: update, style: .default) { (_) in
            var id: String {
                let pattern = "(?<=\\bid)\\d{1,}+\\b"
                guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return "" }
                let id = regex.matches(in: url, options: [], range: NSMakeRange(0, url.characters.count))
                guard let r = id.first?.range else { return "" }
                return (url as NSString).substring(with: r)
            }
            if id != "" {
                let url = "itms-apps://itunes.apple.com/app/id\(id)"
                if let app = URL(string: url) { UIApplication.shared.openURL(app) }
            }
            Wilhelm.happyEnd()
        }
        alert.addAction(updateAction)
        if !forceUpdate {
            let ignoreAction = UIAlertAction(title: ignore, style: .cancel) { (_) in Wilhelm.happyEnd() }
            alert.addAction(ignoreAction)
        }
        DispatchQueue.main.async {
            UIApplication.topMostViewController.showDetailViewController(alert, sender: nil)
        }
    }
}

private extension UIApplication {
    static var topMostViewController: UIViewController {
        var root = UIApplication.shared.windows.first?.rootViewController
        while(root == nil) { root = UIApplication.shared.windows.first?.rootViewController }
        var topController: UIViewController? = root
        while (topController?.presentedViewController != nil) { topController = topController?.presentedViewController }
        return topController!
    }
}
