//
//  CustomDiaryQuoteMessageCell.swift
//  ChatExample
//
//  Created by Justin Lai on 2023/9/12.
//  Copyright © 2023 MessageKit. All rights reserved.
//

import MessageKit
import UIKit

class CustomDiaryQuoteMessageCell: DiaryQuoteMessageCell {
    override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        switch message.kind {
        case .diaryQuote(let item):
            for (index, _) in item.photoURLs.enumerated() {
                let imageView = (index == 0) ? diaryFirstImageView : diarySecondImageView
                let image = (index == 0) ? UIImage(imageLiteralResourceName: "img1") : UIImage(imageLiteralResourceName: "img2")
                imageView.image = image
            }
        default:
            break
        }

    }
}

