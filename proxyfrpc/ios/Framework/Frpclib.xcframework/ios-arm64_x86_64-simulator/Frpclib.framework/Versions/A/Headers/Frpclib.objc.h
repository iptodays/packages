// Objective-C API for talking to github.com/fatedier/frp/cmd/frpc Go package.
//   gobind -lang=objc github.com/fatedier/frp/cmd/frpc
//
// File is generated by gobind. Do not edit.

#ifndef __Frpclib_H__
#define __Frpclib_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


// skipped function AllUids with unsupported parameter or return types


FOUNDATION_EXPORT BOOL FrpclibIsRunning(NSString* _Nullable uid);

FOUNDATION_EXPORT void FrpclibStart(NSString* _Nullable uid, NSString* _Nullable cfgFilePath);

FOUNDATION_EXPORT BOOL FrpclibStop(NSString* _Nullable uid);

#endif
