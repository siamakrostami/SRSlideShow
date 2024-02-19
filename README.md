# SRSlideShow

SRSlideShow is a versatile slideshow library written in Swift, designed to provide easy integration of customizable slideshow features into iOS applications.

## Features

- Easy integration into your iOS app.
- Responsive layouts for optimal viewing experiences across different devices and orientations.
- Gesture support including swipe and tap gestures.

## Usage

To integrate SRSlideShow into your project, follow these steps:

1. Add `SRSlideShow.swift` to your project.
2. Create an instance of `SRSlideShow` with the desired frame and slideshow type.
3. Customize the slideshow properties such as background color, corner radius, and banners.
4. Add the `SRSlideShow` instance to your view hierarchy.
5. Enjoy your customized slideshow!

```swift
let slideshow = SRSlideShow(frame: CGRect(x: 0, y: 0, width: 300, height: 200), type: .local)
slideshow.collectionBackgroundColor = .lightGray
slideshow.collectionCornerRadius = 12
slideshow.banners = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3")]
view.addSubview(slideshow)
```
