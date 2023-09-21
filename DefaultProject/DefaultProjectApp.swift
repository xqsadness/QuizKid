//
//  DefaultProjectApp.swift
//  DefaultProject
//
//  Created by CycTrung on 04/06/2023.
//

import SwiftUI
import Firebase
import GoogleMobileAds
import CrowdinSDK

@main
struct DefaultProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RootView().preferredColorScheme(.dark)
        }
    }
}

struct RootView: SwiftUI.View {
    @StateObject var appController = APPCONTROLLER.shared
    @StateObject var user = User.shared
    @StateObject var coordinator = Coordinator.shared
    @StateObject var alerter: Alerter = Alerter.shared
    @AppStorage("FIRST_LOAD_APP") var FIRST_LOAD_APP = false
    @AppStorage("USERNAME") var USERNAME: String = ""
    @AppStorage("Language") var language: String = "en"
    
    var body: some SwiftUI.View {
        NavigationStack(path: $coordinator.path) {
            Group{
                if appController.SHOW_OPEN_APPP{
                    ZStack{
                        Image("AppIconSingle")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.background2)
                    .overlay(alignment: .bottom) {
                        //https://lottiefiles.com/9329-loading
                        LottieView(name: "loading_default", loopMode: .loop)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                    }
                }
                else{
                    ContentView()
                }
            }
            .environmentObject(appController)
            .environmentObject(user)
            .environmentObject(coordinator)
            .environmentObject(alerter)
            .navigationBarHidden(true)
            .navigationDestination(for: Page.self) { page in
                coordinator.build(page: page)
            }
            .sheet(item: $coordinator.sheet) { sheet in
                coordinator.build(sheet: sheet)
            }
            .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreencover in
                coordinator.build(fullScreenCover: fullScreencover)
            }
            .onAppear(perform: {
                if !FIRST_LOAD_APP{
                    let deviceLanguage = checkDeviceLanguage()
                    language = deviceLanguage
                    CrowdinSDK.currentLocalization = language
                    
                    let point = Point(pointColor: 0)
                    Point.savePoint(point: point)
                    FIRST_LOAD_APP = true
                }
                if !appController.SHOW_OPEN_APPP{
                    return
                }
                CONSTANT.SHARED.load {
                    appController.SHOW_OPEN_APPP = true
                    self.openApp()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
                        withAnimation {
                            appController.SHOW_OPEN_APPP = false
                        }
                    })
                }
                
                CONSTANT.SHARED.loadData{
                    CONSTANT.SHARED.cancellable?.cancel()
                }
            })
            .onChange(of: appController.INDEX_TABBAR, perform: { b in
                if User.isShowInterstitial() == false{
                    return
                }
                appController.COUNT_INTERSTITIAL += 1
                if appController.COUNT_INTERSTITIAL % CONSTANT.SHARED.ADS.INTERVAL_INTERSTITIAL == 0{
                    InterstitialAd.shared.show()
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (output) in
                if User.isShowRate(){
                    MyAlert.showRate()
                }
                else{
                    if User.isShowAdsOpen(){
                        AdsOpenAd.shared.show()
                    }
                }
            }
            .alert(isPresented: $alerter.isShowingAlert) {
                alerter.alert ?? Alert(title: Text(""))
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PushMessage"))) { (output) in
            DispatchQueue.main.async {
                guard let str = output.userInfo?["data"] as? String else {return}
                
                appController.MESSAGE_ON_SCREEN = str
                withAnimation(.easeInOut(duration: 1)) {
                    appController.SHOW_MESSAGE_ON_SCREEN  = true
                }
                appController.TIMER_MESSAGE_ON_SCREEN?.invalidate()
                appController.TIMER_MESSAGE_ON_SCREEN = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                    withAnimation(.easeInOut(duration: 1)){
                        appController.SHOW_MESSAGE_ON_SCREEN  = false
                    }
                })
            }
        }
        .overlay(alignment: .bottom, content: {
            appController.SHOW_MESSAGE_ON_SCREEN ?
            NotificationView()
            : nil
        })
    }
    
    func openApp(){
        User.shared.getUser()
        GADMobileAds.sharedInstance().start(completionHandler: {_ in
            GADMobileAds.sharedInstance().applicationMuted = true
        })
    }
    
    func checkDeviceLanguage() -> String {
        let preferredLanguage = Locale.preferredLanguages[0]
        return preferredLanguage
    }
}

