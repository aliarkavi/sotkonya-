import UIKit
import Flutter

class SceneDelegate: FlutterSceneDelegate {

    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        print("🔥🔥🔥 SceneDelegate WILL CONNECT")
        
        super.scene(
            scene,
            willConnectTo: session,
            options: connectionOptions
        )
    }

    override func sceneDidBecomeActive(_ scene: UIScene) {
        print("🔥🔥🔥 SceneDelegate DID BECOME ACTIVE")
        super.sceneDidBecomeActive(scene)
    }
}
