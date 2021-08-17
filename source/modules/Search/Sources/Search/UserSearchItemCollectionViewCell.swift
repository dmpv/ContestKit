//
//  File.swift
//  
//
//  Created by Dmitry Purtov on 17.08.2021.
//

import Foundation
import UIKit

import SnapKit
import Nuke

import ToolKit
import NutsonCore

public protocol UserSearchItemCollectionViewCellComponents {
}

public final class UserSearchItemCollectionViewCell: UICollectionViewCell {
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

    var components: UserSearchItemCollectionViewCellComponents?

    private var currentLayout: Layout?

    private var horStackView: UIStackView!

    private var avatarImageView: UIImageView!

    private var rightVertStackView: UIStackView!
    private var nameLabel: UILabel!
    private var statusLabel: UILabel!

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

        horStackView = UIStackView().applying(noAutoresize).applying {
            $0.alignment = .center
            $0.spacing = 12
        }
        contentView.addSubview(horStackView)

        avatarImageView = UIImageView()
        horStackView.addArrangedSubview(avatarImageView)

        rightVertStackView = UIStackView().applying(noAutoresize).applying {
            $0.axis = .vertical
        }
        horStackView.addArrangedSubview(rightVertStackView)

        nameLabel = UILabel().applying {
            $0.font = .bold(withSize: 12)
            $0.textColor = .fullBlack
        }
        rightVertStackView.addArrangedSubview(nameLabel)

        statusLabel = UILabel().applying {
            $0.font = .regular(withSize: 12)
            $0.textColor = .grey_70
        }
        rightVertStackView.addArrangedSubview(statusLabel)
    }

    private func dataDidChange(from oldData: Data?) {
        viewData = state?.data.viewData

        Nuke.loadImage(
            with: ImageRequest(
                url: state?.data.item.avatarURL,
                processors: [ImageProcessors.Circle()]
            ),
            into: avatarImageView
        )

        nameLabel.text = state?.data.item.name
        statusLabel.text = state?.data.formattedStatus
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

        horStackView.snp.updateConstraints {
            $0.edges.equalTo(contentView.layoutMarginsGuide).flexible()
        }

        avatarImageView.snp.updateConstraints {
            $0.size.equalTo(CGSize(width: 52, height: 52))
        }
    }
}

extension UserSearchItemCollectionViewCell {
    public struct State: StateType {
        var data: Data
        var layout: Layout = .init()
        var appearance: Appearance = .init()
    }

    public struct Data: StateType {
        var viewData: UIView.Data = .make()
        var item: UserSearchItem
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

extension UserSearchItemCollectionViewCell.Data {
    var formattedStatus: String {
        "\(formattedFollowerCount) - \(formattedMediaCount) - \(formattedChallengeCount)"
    }

    private var formattedFollowerCount: String {
        String("\(item.followerCount)".prefix(3) + " Followers")
    }

    private var formattedMediaCount: String {
        String("\(item.mediaCount)".prefix(3) + " Videos")
    }

    private var formattedChallengeCount: String {
        String("\(item.challengeCount)".prefix(3) + " Challenges")
    }
}
