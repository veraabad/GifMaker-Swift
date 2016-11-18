# GifMaker-Swift
GifMaker app completely written in Swift

# Overview

GifMaker is an app that lets users create simple GIF animations from their iOS device. This specific implementation is written exclusively in Swift. The GifMaker app is used as an example throughout Udacity's Objective-C for Swift Developers course.

# Purpose

The purpose of doing this is to demonstrate my ability in both understanding Objective-C and being able to translate it to Swift. In my opinion the code can be understood better when written in Swift and therefore it should be easier to maintain and upgrade in the future.

# Changes

The main difference from this app to its Objective-C counter part is that its written completely in Swift. There are also a few other architectural changes in this re-write. One of them was to load the saved gifs from a view controller instead of having them be loaded by the AppDelegate. 

Functionality remains pretty much the same. I did add the capability to delete gifs from the SavedGifsViewController. It seemed like an adequate addition since you couldn't delete any of the gifs saved. 

# How it was accomplished

Translation for this project was pretty straightforward. A lot of the syntax translated could almost be written as it was in Objective-C. One example can be found with the function "cropVideoToSquare". Check out the first two lines:

Objective-C:

//Create the AVAsset and AVAssetTrack

  AVAsset *videoAsset = [AVAsset assetWithURL:rawVideoURL];
  
  AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];

Swift:

// Create AVAsset and AVAssetTrack

  let videoAsset = AVAsset(url: rawVideoURL as URL)
  
  let videoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0]
  
 As you can see, both lines are pretty much the same. 
