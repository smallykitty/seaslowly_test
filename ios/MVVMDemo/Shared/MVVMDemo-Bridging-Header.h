//
//  MVVMDemo-Bridging-Header.h
//  MVVMDemo
//
//  Use this file to import Objective-C headers that you want to expose to Swift.
//

#import "../Services/ObjCHelper.h"

// Import MVVM Core Models for Objective-C compatibility
#import "../Models/UserCredentials.h"
#import "../Models/AuthenticationResponse.h"
#import "../Models/ValidationError.h"
#import "../Models/ValidationHelpers.h"

// Import MVVM Core Services for Objective-C compatibility
#import "../Services/ValidationService.h"
