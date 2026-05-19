import AdSupport
import AppTrackingTransparency
import Flutter
import UIKit

public class AppTrackingTransparencyPlugin: NSObject, FlutterPlugin {
  private var observer: NSObjectProtocol?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "app_tracking_transparency", binaryMessenger: registrar.messenger())
    let instance = AppTrackingTransparencyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getTrackingAuthorizationStatus":
      getTrackingAuthorizationStatus(result: result)
    case "requestTrackingAuthorization":
      requestTrackingAuthorization(result: result)
    case "getAdvertisingIdentifier":
      getAdvertisingIdentifier(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func getTrackingAuthorizationStatus(result: @escaping FlutterResult) {
    if #available(iOS 14, *) {
      result(Int(ATTrackingManager.trackingAuthorizationStatus.rawValue))
    } else {
      result(Int(4))
    }
  }

  private func requestTrackingAuthorization(result: @escaping FlutterResult) {
    if #available(iOS 14, *) {
      removeObserver()

      ATTrackingManager.requestTrackingAuthorization { [weak self] status in
        if status == .denied, ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
          print("iOS 17.4 authorization bug detected")
          self?.addObserver(result: result)
          return
        }
        result(Int(status.rawValue))
      }
    } else {
      result(Int(4))
    }
  }

  private func getAdvertisingIdentifier(result: @escaping FlutterResult) {
    result(String(ASIdentifierManager.shared().advertisingIdentifier.uuidString))
  }

  private func addObserver(result: @escaping FlutterResult) {
    removeObserver()
    observer = NotificationCenter.default.addObserver(
      forName: UIApplication.didBecomeActiveNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      self?.requestTrackingAuthorization(result: result)
    }
  }

  private func removeObserver() {
    if let observer = observer {
      NotificationCenter.default.removeObserver(observer)
      self.observer = nil
    }
  }
}

public typealias SwiftAppTrackingTransparencyPlugin = AppTrackingTransparencyPlugin
