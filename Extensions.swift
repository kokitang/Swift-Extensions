//
//  Extensions.swift
//  xDatabase
//
//  Created by Koki Tang on 29/9/2017.
//  Copyright © 2017年 Koki Tang. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import DateTimePicker

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kScreenRect = UIScreen.main.bounds

import UIKit

func viewController(forStoryboardName: String) -> UIViewController {
    return UIStoryboard(name: forStoryboardName, bundle: nil).instantiateInitialViewController()!
}

func topPresentingController() -> UIViewController? {
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    
    return nil
}

func statusBarHeight() -> CGFloat {
    let statusBarSize = UIApplication.shared.statusBarFrame.size
    return Swift.min(statusBarSize.width, statusBarSize.height)
}

func sendWhatsapp(text: String, to contact:String?) {
    var urlWhats = ""
    if let contact = contact {
        urlWhats = "whatsapp://send?phone=\(contact)&text=\(text)"
    } else {
        urlWhats = "whatsapp://send?text=\(text)"
    }
    
    // By APP scheme
    // Using App Scheme have to include "whatsapp" of "LSApplicationQueriesSchemes" in "Info.plist"
    if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
        if let whatsappURL = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.openURL(whatsappURL)
            } else {
                print("Install Whatsapp")
            }
        }
    }
    
    // By Web API
//    let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=+85264087633&text=Invitation")
//    if UIApplication.shared.canOpenURL(whatsappURL!) {
//        UIApplication.shared.openURL(whatsappURL!)
//    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

extension String {
    public static func utf8(string: String) -> String {
        if let cString = string.cString(using: .isoLatin1) {
            return String.init(utf8String: cString)!
        } else {
            return string
        }
    }
    
    func utf8String() -> String {
        if let cString = self.cString(using: .isoLatin1) {
            return String.init(utf8String: cString)!
        } else {
            return self
        }
    }
    
    func apiLanguageKey() -> String {
        if self == "zh-Hant" {
            return "tw"
        } else if self == "zh-Hans" {
            return "cn"
        } else {
            return "en"
        }
    }
    
    public static func APILanguageKey(languageKey: String) -> String {
        if languageKey == "zh-Hant" {
            return "tw"
        } else if languageKey == "zh-Hans" {
            return "cn"
        } else {
            return "en"
        }
    }
    
    public static func awesomeFontIconString(string: String?) -> String {
        //      FONT-AWESOME ICON
        //        "<i class='fa fa-floppy-o'></i>"
        //        to
        //        fa-floppy-o
        if let str1 : [String?] = string?.components(separatedBy: " ").filter({!$0.isEmpty}){
            if str1.count > 1 {
                if let str2 : [String?] = str1[2]?.components(separatedBy: "\'") {
                    if str2.count > 0 {
                        if let iconString = str2[0] {
                            return iconString
                        }
                    }
                }
            }
        }
        //str1 == nil
        return ""
    }
    
    func isVersionNewer(compareVersion: String) -> Bool {
        if self.compare(compareVersion, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending {
            return true
        }
        return false
    }
        
}

extension UILabel {
    
    func setCharacterSpacing(characterSpacing: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Character spacing attribute
        attributedString.addAttribute(NSAttributedStringKey.kern, value: characterSpacing, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
}

extension UIWindow {
    open class func frontWindow() -> UIWindow? {
        for window in UIApplication.shared.windows {
            let windowOnMainScreen = window.screen == UIScreen.main
            let windowIsVisible = !window.isHidden && window.alpha > 0
            let windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal)
            let windowKeyWindow = window.isKeyWindow
            if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
                return window
            }
        }
        return nil
    }
//    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
//    for (UIWindow *window in frontToBackWindows) {
//    BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
//    BOOL windowIsVisible = !window.hidden && window.alpha > 0;
//    BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= self.maxSupportedWindowLevel);
//    BOOL windowKeyWindow = window.isKeyWindow;
//
//    if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
//    return window;
//    }
//    }
//    return nil;
//    }

}

public extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        
        set {
            layer.shadowOpacity = newValue
        }
    }
    @IBInspectable public var shadowColor: UIColor? {
        get {
            return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil
        }
        
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        
        set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable public var zPosition: CGFloat {
        get {
            return layer.zPosition
        }
        
        set {
            layer.zPosition = newValue
        }
    }
    
    func removeAllSubViews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }

    // for UITextField
    func leftPaddingView(width: CGFloat, text: String?) -> UIView {
        let paddingView = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 0))
        paddingView.backgroundColor = UIColor.clear
        if text != nil {
            paddingView.text = text
            paddingView.sizeToFit()
        }
        return paddingView
    }
    
    func rightImageView(width: CGFloat, named: String?) -> UIView {
        let rightView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 0))
        rightView.contentMode = .center
        if named != nil {
            rightView.image = UIImage.init(named: named!)
        }
        return rightView
    }

    func loadViewFromNib(nibName: String) -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func setBottomBorder(color:String = "4B4B4B") {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x : 0.0, y : self.frame.height - 1, width : self.frame.width, height : 1.0)
        // CGRectMake.
        bottomLine.backgroundColor = UIColor.init(hexString: color).cgColor
        
        let bottomV = UIView()
        self.layoutIfNeeded()
        //self.layoutSubviews()
        bottomV.frame = CGRect(x : 0.0, y : self.frame.height - 1, width : self.frame.size.width, height : 1.0)
        bottomV.backgroundColor = hexStringToUIColor(hex: color)
        
        self.borderStyle = UITextBorderStyle.none
        self.addSubview(bottomV)
        //self.layer.addSublayer(bottomLine)
    }
    
    func fadeIn(duration: TimeInterval = 0.25, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.25, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func asImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            guard let currentContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: currentContext)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
}

extension UIViewController: UIDocumentInteractionControllerDelegate {
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.modalPresentationStyle = .overCurrentContext
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
    
    func dismissTo (_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.modalPresentationStyle = .fullScreen
        present(viewControllerToPresent, animated: false)
    }
    
    func presentFromTop(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.modalPresentationStyle = .overCurrentContext
        present(viewControllerToPresent, animated: false)
    }
    
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        // I tend to use 'navigationController ?? self' here but depends on implementation
        return self
    }
}

extension UIResponder {
    func parentController<T: UIViewController>(of type: T.Type) -> T? {
        guard let next = self.next else {
            return nil
        }
        return (next as? T) ?? next.parentController(of: T.self)
    }
}

extension Notification.Name {
    static let languageViewTouchUpInside = Notification.Name(rawValue: "languageViewTouchUpInside")
    static let dataUpdated = Notification.Name(rawValue: "dataUpdated")
    static let uploadFile = Notification.Name(rawValue: "uploadFile")
}

extension UIColor {
    // Create UIColor from hex string, support for both "#ffffff" & "ffffff" format, any cased
    public convenience init(hexString: String) {
        
        var uppercasedString = hexString.uppercased()
        if uppercasedString.hasPrefix("#") {
            uppercasedString.remove(at: hexString.startIndex)
        }

        var rgbValue: UInt32 = 0
        Scanner(string: uppercasedString).scanHexInt32(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static func random() -> UIColor {
        return UIColor(red:   .random() * 0.9,
                       green: .random() * 0.9,
                       blue:  .random() * 0.9,
                       alpha: 1.0)
    }
    
    func isLight() -> Bool {
        if let colorSpace = self.cgColor.colorSpace {
            if colorSpace.model == .rgb {
                guard let components = cgColor.components, components.count > 2 else {return false}
                
                let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
                
                return (brightness > 0.5)
            }
            else {
                var white : CGFloat = 0.0
                
                self.getWhite(&white, alpha: nil)
                
                return white >= 0.5
            }
        }
        
        return false
    }
}

extension UIFont {
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}

extension Date {
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
}

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat.pi)
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat.pi
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: .zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap?.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        
        //   // Rotate the image context
        bitmap?.rotate(by: degreesToRadians(degrees))
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap?.scaleBy(x: yFlip, y: -1.0)
        let rect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
        
        bitmap?.draw(cgImage!, in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    public func rotateRight() -> UIImage {
        return self.imageRotatedByDegrees(degrees: 90, flip: false)
    }
    
    public func rotateLeft() -> UIImage {
        return self.imageRotatedByDegrees(degrees: -90, flip: false)
    }
    
    public func rotateUpsideDown() -> UIImage {
        return self.imageRotatedByDegrees(degrees: 180, flip: false)
    }
    
    public func flip() -> UIImage {
        return self.imageRotatedByDegrees(degrees: 0, flip: true)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}

class ContactUILabel: UILabel, UIGestureRecognizerDelegate {
    var whatsappUrl: URL? {
        didSet {
            if whatsappUrl != nil {
                self.textColor = UIColor.hexStringToUIColor(hex: "007AFF")
                //                setTap()
            } else {
                self.textColor = UIColor.hexStringToUIColor(hex: "484848")
            }
            print("did set whatsapp url & text color")
        }
    }
    
    var wechatId: String? {
        didSet {
            if wechatId != nil {
                self.textColor = UIColor.hexStringToUIColor(hex: "007AFF")
                //                setTap()
            } else {
                self.textColor = UIColor.hexStringToUIColor(hex: "484848")
            }
            print("did set wechat ID & text color")
        }
    }
    
    var location: CLLocationCoordinate2D? {
        didSet {
            if location != nil {
                self.textColor = UIColor.hexStringToUIColor(hex: "007AFF")
                //                setTap()
            } else {
                self.textColor = UIColor.hexStringToUIColor(hex: "484848")
            }
            print("did set location & text color")
        }
    }
    var placeName = ""
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func setTap(_ delegate: UIGestureRecognizerDelegate? = nil) {
        print("setTap")
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapped))
        tap.delegate = self
        
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapped() {
        print("tapped label")
        if whatsappUrl != nil {
            UIApplication.shared.open(whatsappUrl!)
        } else if location != nil {
            MapKit.openMapForPlace(lat: location!.latitude, long: location!.longitude, placeName: placeName)
        } else if wechatId != nil {
            UIPasteboard.general.string = wechatId
            Toast.init(text: "Copied Accountant's WeChat ID to clipboard").show()
        }
    }
    
    func setWhatsApp(_ number: String) {
        self.text = number
        let n = number.replacingOccurrences(of: " ", with: "")
        let whatsappURL3 = URL(string: "https://api.whatsapp.com/send?phone=+852\(n)")
        let whatsappURL2 = URL(string: "https://api.whatsapp.com/send?phone=+\(n)")
        let whatsappURL1 = URL(string: "https://api.whatsapp.com/send?phone=\(n)")
        
        if UIApplication.shared.canOpenURL(whatsappURL1!) {
            whatsappUrl = whatsappURL1
        } else if UIApplication.shared.canOpenURL(whatsappURL2!) {
            whatsappUrl = whatsappURL2
        } else if UIApplication.shared.canOpenURL(whatsappURL3!) {
            whatsappUrl = whatsappURL3
        } else {
            print("whatsapp is nil")
            whatsappUrl = nil
        }
    }
    
    func setAddress(_ address: String, placeName: String = "") {
        self.text = address
        MapKit.coordinates(forAddress: address) {
            location in
            guard let location = location else {
                // Handle error here.
                print("Location is nil")
                self.location = nil
                return
            }
            self.placeName = placeName
            self.location = location
        }
    }
    
    func setWeChat(_ id: String) {
        self.text = id
        wechatId = id
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class MapKit {
    static func openMapForPlace(lat:Double = 0, long:Double = 0, placeName:String = "") {
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long
        
        let regionDistance:CLLocationDistance = 100
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: options)
    }
    
    static func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
}

//
//extension Alamofire.SessionManager{
//    
//    @discardableResult
//    open func requestWithCacheOrLoad(
//        _ url: URLConvertible,
//        method: HTTPMethod = .get,
//        parameters: Parameters? = nil,
//        encoding: ParameterEncoding = JSONEncoding.default,
//        headers: HTTPHeaders? = nil)
//        -> DataRequest
//    {
//        do {
//            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
//            urlRequest.cachePolicy = .returnCacheDataElseLoad
//            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
//            return request(encodedURLRequest)
//        } catch {
//            print(error)
//            return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
//        }
//    }
//}

//import UIKit
//import Alamofire

class FileKit: ProgressViewDelegate {
    
    open class func takeFile(from viewController: UIViewController&UIDocumentMenuDelegate) {
        let documentProviderMenu = UIDocumentMenuViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
        documentProviderMenu.delegate = viewController
        viewController.present(documentProviderMenu, animated: true, completion: nil)
    }
    
    /*
     httpCache: Decide how to preview HTTP protocol resources. If true, download and cached; If false, open in external browser (Default is Safari)
     */
    open class func showFile(from viewController: UIViewController&UIDocumentInteractionControllerDelegate, url: URL, httpCache: Bool = true) {
        if url.absoluteString.hasPrefix("http") {
            if httpCache {
                // Download file & show preview
                self.downloadFile(from: viewController, link: url.absoluteString, theme: .Dark)
            } else {
                // Open file in Safari, without download to cache
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            }
        } else {
            let doc = UIDocumentInteractionController.init(url: url)
            doc.delegate = viewController
            if doc.presentPreview(animated: true) {
                // Successfully displayed
            } else {
                // Couldn't display
            }
        }
    }
    
    /* FileKit.downloadFile(from: self, link: "https://www.gnu.org/s/hello/manual/hello.pdf") */
    open class func downloadFile(from viewController: UIViewController&UIDocumentInteractionControllerDelegate, link: String, theme: ProgressViewTheme = .Default) {
        // Clear Cache
        clearCachedFile(forLink: link)
        
        // Initializing
        var req: DownloadRequest? = nil
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        let url = URL.init(string: link)
        
        // Show Download layer
        let progressView = ProgressView.init(frame: kScreenRect, labelKey: "downloading", theme: theme) {
            req?.cancel()
            }.show()
        
        // Start Downloading
        req = Alamofire.download(url!, to: destination).downloadProgress { progress in
            print(progress.fractionCompleted)
            // Update Progress
            progressView.setProgress(progress: Float(progress.fractionCompleted))
            }.response { downloadResponse in
                // Dismiss Download layer
                progressView.dismiss(completionHandler: { success in
                    if downloadResponse.error != nil {
                        // TODO: handle error
                    } else {
                        // Show Preview of downloaded file
                        if let url = downloadResponse.destinationURL {
                            let doc = UIDocumentInteractionController.init(url: url)
                            doc.delegate = viewController
                            if doc.presentPreview(animated: true) {
                                // Successfully displayed
                            } else {
                                // Couldn't display
                            }
                        }
                    }
                })
        }
    }
    
    open class func deleteFile(from viewController: UIViewController? = nil, url:URL) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            print("FILE AVAILABLE")
            do {
                try fileManager.removeItem(at: url)
            } catch {
                print(error)
            }
        } else {
            print("FILE NOT AVAILABLE")
        }
    }
    
    open class func clearCachedFile(forLink link: String) {
        let s = link.components(separatedBy: "/")
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        
        let filePath = url.appendingPathComponent(s.last!).path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            print("FILE AVAILABLE")
            do {
                try fileManager.removeItem(atPath: filePath)
                print("Cache Cleaned")
            } catch {
                print(error)
            }
        }
    }
}

