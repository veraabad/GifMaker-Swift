//
//  AVAssetImageGeneratorTimePoints.swift
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/1/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import AVFoundation

public extension AVAssetImageGenerator {
    public func generateCGImagesAsynchronouslyForTimePoints(timePoints: [TimePoint], completionHandler: @escaping AVAssetImageGeneratorCompletionHandler) {
        let times = timePoints.map {timePoint in
            return NSValue.init(time: timePoint)
        }
        self.generateCGImagesAsynchronously(forTimes: times, completionHandler: completionHandler)
    }
}
