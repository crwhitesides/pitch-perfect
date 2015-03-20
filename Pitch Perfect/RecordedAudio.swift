//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Christian Whitesides on 3/13/15.
//  Copyright (c) 2015 ChristianWhitesides. All rights reserved.
//

import Foundation


class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL
    var title: String
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}