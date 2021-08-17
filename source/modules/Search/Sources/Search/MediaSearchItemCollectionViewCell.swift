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

    private var previewImageView: UIImageView!
    private var impressionIconImageView: UIImageView!
    private var impressionCountLabel: UILabel!

    private var bottomHorStackView: UIStackView!
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
        contentView.applying {
            $0.layoutMargins = .zero
        }

        previewImageView = UIImageView().applying {
            $0.contentMode = .scaleAspectFill
            // dp-performance-TODO: Consider clipping images on load instead of heavy clipsToBounds
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }
        contentView.addSubview(previewImageView)

        impressionIconImageView = UIImageView().applying {
            $0.image = UIImage(named: "icon-basic-impressions", in: .module, with: nil)
        }
        contentView.addSubview(impressionIconImageView)

        impressionCountLabel = UILabel().applying {
            $0.font = .regular(withSize: 12)
            $0.textColor = .fullWhite
        }
        contentView.addSubview(impressionCountLabel)

        bottomHorStackView = UIStackView().applying(noAutoresize).applying {
            $0.alignment = .center
            $0.spacing = 4
        }
        contentView.addSubview(bottomHorStackView)

        userAvatarImageView = UIImageView()
        bottomHorStackView.addArrangedSubview(userAvatarImageView)

        userNameLabel = UILabel().applying {
            $0.font = .bold(withSize: 8)
            $0.textColor = .fullBlack
        }
        bottomHorStackView.addArrangedSubview(userNameLabel)

        likeIconImageView = UIImageView().applying {
            $0.image = UIImage(named: "icon-basic-like", in: .module, with: nil)
        }
        bottomHorStackView.addArrangedSubview(likeIconImageView)

        likeCountLabel = UILabel().applying {
            $0.font = .bold(withSize: 8)
            $0.textColor = .fullBlack
        }
        bottomHorStackView.addArrangedSubview(likeCountLabel)
    }

    private func dataDidChange(from oldData: Data?) {
        viewData = state?.data.viewData

        Nuke.loadImage(
            with: ImageRequest(
                url: state?.data.item.previewURL,
                processors: [
//                    ImageProcessors.Resize(size: imageView.bounds.size),
//                    ImageProcessors.RoundedCorners(radius: 8),
                ],
                priority: .veryHigh
            ),
            into: previewImageView
        )

        impressionCountLabel.text = state?.data.formattedImpressionCount

        Nuke.loadImage(
            with: ImageRequest(
                url: state?.data.item.userAvatarURL,
                processors: [ImageProcessors.Circle()]
            ),
            into: userAvatarImageView
        )

        userNameLabel.text = state?.data.item.userName
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

        previewImageView.snp.updateConstraints {
            $0.top.leading.trailing.equalTo(contentView.layoutMarginsGuide).flexible()
        }

        bottomHorStackView.snp.updateConstraints {
            $0.top.equalTo(previewImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(contentView.layoutMarginsGuide).inset(8).flexible()
            $0.bottom.equalTo(contentView.layoutMarginsGuide).flexible()
            $0.height.equalTo(16)
        }

        // dp-design-TODO: set correct layout after design fix
        impressionIconImageView.snp.updateConstraints {
            $0.leading.bottom.equalTo(previewImageView).inset(8)
            $0.size.equalTo(CGSize(width: 16, height: 16))
        }

        impressionCountLabel.snp.updateConstraints {
            $0.leading.equalTo(impressionIconImageView.snp.trailing).offset(4)
            $0.centerY.equalTo(impressionIconImageView.snp.centerY)
        }

        userAvatarImageView.snp.updateConstraints {
            $0.size.equalTo(CGSize(width: 16, height: 16))
        }

        likeIconImageView.snp.updateConstraints {
            $0.size.equalTo(CGSize(width: 16, height: 16))
        }

        userNameLabel.snp.contentHuggingHorizontalPriority = 51
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
