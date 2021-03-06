/*
 MIT License

 Copyright (c) 2017-2019 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import class AVFoundation.AVAudioPlayer

/// A protocol used to represent the data for an audio message.
public protocol AudioItem: MediaItem {
    /// The text.
    var text: NSAttributedString { get }
    /// The text view's content inset
    var textViewContentInset: UIEdgeInsets { get }
    /// The line's color
    var lineColor: UIColor { get }
    /// The image's height
    var imageHeight: CGFloat { get }
    /// The text view's height
    var textViewHeight: CGFloat { get }
    /// The url where the audio file is located.
    var audioURL: URL { get }
    /// The audio file duration in seconds.
    var audioDuration: Float { get }
    /// The size of the audio item.
    var audioSize: CGSize { get }
}
