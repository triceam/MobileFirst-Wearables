// Copyright 2014 IBM Corp. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import IMFCore

extension IMFLogger {
    
    //Log methods with no metadata
    
    func logTraceWithMessages(message:String, _ args: CVarArgType...) {
        logWithLevel(.Trace, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    func logDebugWithMessages(message:String, _ args: CVarArgType...) {
        logWithLevel(.Debug, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    func logInfoWithMessages(message:String, _ args: CVarArgType...) {
        logWithLevel(.Info, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    func logWarnWithMessages(message:String, _ args: CVarArgType...) {
        logWithLevel(.Warn, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    func logErrorWithMessages(message:String, _ args: CVarArgType...) {
        logWithLevel(.Error, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    func logFatalWithMessages(message:String, _ args: CVarArgType...) {
        logWithLevel(.Fatal, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    func logAnalyticsWithMessages(message:String, _ args: CVarArgType...) {
        logWithLevel(.Analytics, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
    }
    
    //Log methods with metadata
    
    func logTraceWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArgType...) {
        logWithLevel(.Trace, message: message, args:getVaList(args), userInfo:userInfo)
    }
    
    func logDebugWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArgType...) {
        logWithLevel(.Debug, message: message, args:getVaList(args), userInfo:userInfo)
    }
    
    func logInfoWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArgType...) {
        logWithLevel(.Warn, message: message, args:getVaList(args), userInfo:userInfo)
    }
    
    func logWarnWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArgType...) {
        logWithLevel(.Trace, message: message, args:getVaList(args), userInfo:userInfo)
    }
    
    func logErrorWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArgType...) {
        logWithLevel(.Error, message: message, args:getVaList(args), userInfo:userInfo)
    }
    
    func logFatalWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArgType...) {
        logWithLevel(.Fatal, message: message, args:getVaList(args), userInfo:userInfo)
    }
    
    func logAnalyticsWithUserInfo(userInfo:Dictionary<String, String>, message:String, _ args: CVarArgType...) {
        logWithLevel(.Analytics, message: message, args:getVaList(args), userInfo:userInfo)
    }
}

//Swift IMFLogger Macro Alternatives

private func _metadataDictionary(file:NSString, fn:String, line:Int) -> Dictionary<String, String> {
    return [
        KEY_METADATA_METHOD : fn,
        KEY_METADATA_FILE : file.lastPathComponent,
        KEY_METADATA_LINE : String(line),
        KEY_METADATA_SOURCE: SOURCE_SWIFT
    ];
}

public func IMFLogTrace(message:String, package:String = IMF_NAME, file: String = __FILE__, fn: String = __FUNCTION__, line: Int = __LINE__, args: CVarArgType...) {
    IMFLogger(forName:package).logWithLevel(IMFLogLevel.Trace, message: message, args:getVaList(args), userInfo: _metadataDictionary(file, fn, line));
}

public func IMFLogDebug(message:String, package:String = IMF_NAME, file: String = __FILE__, fn: String = __FUNCTION__, line: Int = __LINE__, args: CVarArgType...) {
    IMFLogger(forName:package).logWithLevel(IMFLogLevel.Debug, message: message, args:getVaList(args), userInfo: _metadataDictionary(file, fn, line));
}

public func IMFLogInfo(message:String, package:String = IMF_NAME, file: String = __FILE__, fn: String = __FUNCTION__, line: Int = __LINE__, args: CVarArgType...) {
    IMFLogger(forName:package).logWithLevel(IMFLogLevel.Info, message: message, args:getVaList(args), userInfo: _metadataDictionary(file, fn, line));
}

public func IMFLogWarn(message:String, package:String = IMF_NAME, file: String = __FILE__, fn: String = __FUNCTION__, line: Int = __LINE__, args: CVarArgType...) {
    IMFLogger(forName:package).logWithLevel(IMFLogLevel.Warn, message: message, args:getVaList(args), userInfo: _metadataDictionary(file, fn, line));
}

public func IMFLogError(message:String, package:String = IMF_NAME, file: String = __FILE__, fn: String = __FUNCTION__, line: Int = __LINE__, args: CVarArgType...) {
    IMFLogger(forName:package).logWithLevel(IMFLogLevel.Error, message: message, args:getVaList(args), userInfo: _metadataDictionary(file, fn, line));
}

public func IMFLogFatal(message:String, package:String = IMF_NAME, file: String = __FILE__, fn: String = __FUNCTION__, line: Int = __LINE__, args: CVarArgType...) {
    IMFLogger(forName:package).logWithLevel(IMFLogLevel.Fatal, message: message, args:getVaList(args), userInfo: _metadataDictionary(file, fn, line));
}

public func IMFLogAnalytics(message:String, package:String = IMF_NAME, file: String = __FILE__, fn: String = __FUNCTION__, line: Int = __LINE__, args: CVarArgType...) {
    IMFLogger(forName:package).logWithLevel(IMFLogLevel.Fatal, message: message, args:getVaList(args), userInfo: _metadataDictionary(file, fn, line));
}