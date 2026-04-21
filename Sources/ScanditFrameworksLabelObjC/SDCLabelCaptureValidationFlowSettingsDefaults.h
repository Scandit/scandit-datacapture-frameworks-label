/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <ScanditCaptureCore/SDCBase.h>
#import <ScanditLabelCapture/SDCLabelCaptureValidationFlowSettings.h>

NS_ASSUME_NONNULL_BEGIN

SDC_EXPORTED_SYMBOL
NS_SWIFT_NAME(LabelCaptureValidationFlowSettingsDefaults)
@interface SDCLabelCaptureValidationFlowSettingsDefaults : NSObject

// clang-format off
@property (class, nonatomic, nullable, readonly) NSString *defaultMissingFieldsHintText;
@property (class, nonatomic, nullable, readonly) NSString *defaultStandbyHintText;
@property (class, nonatomic, nullable, readonly) NSString *defaultValidationHintText;
@property (class, nonatomic, nullable, readonly) NSString *defaultValidationErrorText;
@property (class, nonatomic, nullable, readonly) NSString *defaultRequiredFieldErrorText;
@property (class, nonatomic, nullable, readonly) NSString *defaultManualInputButtonText;
//clang-format on

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
