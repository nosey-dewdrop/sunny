import SwiftUI

struct FrameAnimationView: View {
    // asset name prefix, e.g. "sun_anim" for sun_anim_0, sun_anim_1, etc.
    let prefix: String
    // total number of frames
    let frameCount: Int
    // seconds per frame
    var fps: Double = 0.12

    @State private var currentFrame = 0

    var body: some View {
        Image("\(prefix)_\(currentFrame)")
            .resizable()
            .scaledToFit()
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: fps, repeats: true) { _ in
                    currentFrame = (currentFrame + 1) % frameCount
                }
            }
    }
}
