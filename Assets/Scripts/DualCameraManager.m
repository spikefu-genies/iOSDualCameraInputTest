#import "DualCameraManager.h"
#import <UIKit/UIKit.h>

@interface DualCameraManager () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoDataOutput *frontOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *backOutput;

@end

@implementation DualCameraManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _captureSession = [[AVCaptureSession alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidReceiveMemoryWarning)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)applicationDidReceiveMemoryWarning {
    // Stop the capture session and release resources if needed
    [self stopDualCameraCapture];
    // Optionally, release other resources or perform other cleanup tasks
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startDualCameraCapture {
    AVCaptureDevice *frontCamera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];

    NSError *error = nil;
    AVCaptureDeviceInput *frontInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    AVCaptureDeviceInput *backInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];

    if ([_captureSession canAddInput:frontInput]) {
        [_captureSession addInput:frontInput];
    }
    if ([_captureSession canAddInput:backInput]) {
        [_captureSession addInput:backInput];
    }

    _frontOutput = [[AVCaptureVideoDataOutput alloc] init];
    _backOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    _frontOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    _backOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};

    dispatch_queue_t queue = dispatch_queue_create("CameraQueue", NULL);
    [_frontOutput setSampleBufferDelegate:self queue:queue];
    [_backOutput setSampleBufferDelegate:self queue:queue];

    if ([_captureSession canAddOutput:_frontOutput]) {
        [_captureSession addOutput:_frontOutput];
    }
    if ([_captureSession canAddOutput:_backOutput]) {
        [_captureSession addOutput:_backOutput];
    }

    [_captureSession startRunning];
}

- (void)stopDualCameraCapture {
    [_captureSession stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);

    // Create a data buffer
    NSData *data = [NSData dataWithBytes:baseAddress length:bytesPerRow * height];
    
    // Send the data buffer to Unity
    if (output == _frontOutput) {
        [self sendDataToUnity:data width:width height:height forFrontCamera:YES];
    } else {
        [self sendDataToUnity:data width:width height:height forFrontCamera:NO];
    }
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

- (void)sendDataToUnity:(NSData *)data width:(size_t)width height:(size_t)height forFrontCamera:(BOOL)isFrontCamera {
    NSString *objectName = isFrontCamera ? @"FrontCameraHandler" : @"BackCameraHandler";
    NSString *methodName = isFrontCamera ? @"UpdateFrontCameraTexture" : @"UpdateBackCameraTexture";
    NSString *dataString = [data base64EncodedStringWithOptions:0];
    const char *dataCStr = [dataString UTF8String];

    UnitySendMessage([objectName UTF8String], [methodName UTF8String], dataCStr);
}

@end
