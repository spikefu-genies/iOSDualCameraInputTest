#import "DualCameraManager.h"

DualCameraManager *manager;

extern "C" {
    void _StartDualCameraCapture() {
        if (!manager) {
            manager = [[DualCameraManager alloc] init];
        }
        [manager startDualCameraCapture];
    }

    void _StopDualCameraCapture() {
        if (manager) {
            [manager stopDualCameraCapture];
        }
    }
}
