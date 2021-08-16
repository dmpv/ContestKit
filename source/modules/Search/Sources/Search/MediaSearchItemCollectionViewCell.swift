//
//  MediaSearchItemCollectionViewCell.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 12.08.2021.
//

import Foundation
import UIKit

import SnapKit
import Nuke

import ToolKit

public protocol MediaSearchItemCollectionViewCellComponents {
}

public final class MediaSearchItemCollectionViewCell: UICollectionViewCell {
    var state: State? {
        didSet(oldState) {
            if state?.data != oldState?.data {
                dataDidChange(from: oldState?.data)
            }

            if state?.appearance != oldState?.appearance {
                appearanceDidChange(from: oldState?.appearance)
            }

            if state?.layout != oldState?.layout {
                layoutDidChange(from: oldState?.layout)
            }
        }
    }

    var handlers = Handlers() {
        didSet { handlersDidChange() }
    }

    var components: MediaSearchItemCollectionViewCellComponents?

    private var currentLayout: Layout?

    private var vertStackView: UIStackView!

    private var previewImageView: UIImageView!
    private var impressionIconImageView: UIImageView!
    private var impressionCountLabel: UILabel!

    private var horStackView: UIStackView!
    private var userAvatarImageView: UIImageView!
    private var userNameLabel: UILabel!
    private var likeIconImageView: UIImageView!
    private var likeCountLabel: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        vertStackView = UIStackView().applying {
            $0.axis = .vertical
        }
        contentView.addSubview(vertStackView)

        previewImageView = UIImageView()
        vertStackView.addArrangedSubview(previewImageView)

        impressionIconImageView = UIImageView()
        contentView.addSubview(impressionIconImageView)

        impressionCountLabel = UILabel()
        contentView.addSubview(impressionCountLabel)

        horStackView = UIStackView()
        vertStackView.addArrangedSubview(horStackView)

        userAvatarImageView = UIImageView()
        horStackView.addArrangedSubview(userAvatarImageView)

        userNameLabel = UILabel().applying {
            $0.font = .bold(withSize: 8)
            $0.textColor = .fullBlack
        }
        horStackView.addArrangedSubview(userNameLabel)

        likeIconImageView = UIImageView()
        horStackView.addArrangedSubview(likeIconImageView)

        likeCountLabel = UILabel()
        horStackView.addArrangedSubview(likeCountLabel)
    }

    private func dataDidChange(from oldData: Data?) {
        viewData = state?.data.viewData

        Nuke.loadImage(
            with: ImageRequest(
                url: state?.data.item.previewURL,
                processors: [
    //                ImageProcessors.Resize(size: imageView.bounds.size),
                    ImageProcessors.RoundedCorners(radius: 8),
                ],
                priority: .veryHigh
            ),
            into: previewImageView
        )

        impressionIconImageView.image = Stub.image(withSize: .init(width: 30, height: 30))
        impressionCountLabel.text = state?.data.formattedImpressionCount

        Nuke.loadImage(
            with: ImageRequest(
                url: state?.data.item.userAvatarURL,
                processors: [ImageProcessors.Circle()]
            ),
            into: userAvatarImageView
        )

        userNameLabel.text = state?.data.item.userName
        likeIconImageView.image = Stub.image(withSize: .init(width: 30, height: 30))
        likeCountLabel.text = state?.data.formattedLikeCount
    }

    private func layoutDidChange(from oldLayout: Layout?) {
        viewLayout = state?.layout.viewLayout
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }

    private func appearanceDidChange(from oldAppearance: Appearance?) {
        viewAppearance = state?.appearance.viewAppearance
    }

    private func handlersDidChange() {
    }

    public override func updateConstraints() {
        defer {
            currentLayout = state?.layout
            super.updateConstraints()
        }
        guard state?.layout != currentLayout else { return }

        vertStackView.snp.updateConstraints {
            $0.edges.equalTo(contentView.layoutMarginsGuide)
        }

        impressionIconImageView.snp.updateConstraints {
            $0.leading.bottom.equalTo(previewImageView).inset(8)
        }

        impressionCountLabel.snp.updateConstraints {
            $0.leading.equalTo(impressionIconImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(impressionIconImageView.snp.centerY)
            $0.trailing.equalTo(previewImageView).inset(8)
        }

        userAvatarImageView.snp.updateConstraints {
            $0.size.equalTo(CGSize(width: 16, height: 16))
        }

        impressionIconImageView.snp.contentHuggingHorizontalPriority = 1000
        likeIconImageView.snp.contentHuggingHorizontalPriority = 1000
    }
}

extension MediaSearchItemCollectionViewCell {
    public struct State: StateType {
        var data: Data
        var layout: Layout = .init()
        var appearance: Appearance = .init()
    }

    public struct Data: StateType {
        var viewData: UIView.Data = .make()
        var item: MediaSearchItem
    }

    public struct Layout: StateType {
        var viewLayout: UIView.Layout = .make()
    }

    public struct Appearance: StateType {
        var viewAppearance: UIView.Appearance = .make()
    }

    struct Handlers {
    }
}

extension MediaSearchItemCollectionViewCell.Data {
    var formattedImpressionCount: String {
        String("\(item.impressionCount)".prefix(10))
    }

    var formattedLikeCount: String {
        String("\(item.likeCount)".prefix(10))
    }
}
