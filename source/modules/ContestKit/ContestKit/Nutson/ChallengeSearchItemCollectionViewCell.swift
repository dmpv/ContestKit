//
//  ChallengeSearchItemCollectionViewCell.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 16.08.2021.
//

import Foundation
import UIKit

import SnapKit
import Nuke

import ToolKit

public protocol ChallengeSearchItemCollectionViewCellComponents {
}

public final class ChallengeSearchItemCollectionViewCell: UICollectionViewCell {
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

    var components: ChallengeSearchItemCollectionViewCellComponents?

    private var currentLayout: Layout?

    private var horStackView: UIStackView!

    private var statusImageView: UIImageView!

    private var centralVertStackView: UIStackView!
    private var nameLabel: UILabel!
    private var statusLabel: UILabel!

    private var rightVertStackView: UIStackView!
    private var rightTopHorStackView: UIStackView!
    private var mediaCountLabel: UILabel!
    private var mediaIconImageView: UIImageView!
    private var rightBottomHorStackView: UIStackView!
    private var rewardLabel: UILabel!
    private var rewardIconImageView: UIImageView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        horStackView = UIStackView()
        contentView.addSubview(horStackView)

        statusImageView = UIImageView()
        horStackView.addArrangedSubview(statusImageView)

        centralVertStackView = UIStackView().applying {
            $0.axis = .vertical
        }
        horStackView.addArrangedSubview(centralVertStackView)

        nameLabel = UILabel()
        centralVertStackView.addArrangedSubview(nameLabel)

        statusLabel = UILabel()
        centralVertStackView.addArrangedSubview(statusLabel)

        rightVertStackView = UIStackView().applying {
            $0.axis = .vertical
        }
        horStackView.addArrangedSubview(rightVertStackView)

        rightTopHorStackView = UIStackView()
        rightVertStackView.addArrangedSubview(rightTopHorStackView)

        mediaCountLabel = UILabel()
        rightTopHorStackView.addArrangedSubview(mediaCountLabel)

        mediaIconImageView = UIImageView()
        rightTopHorStackView.addArrangedSubview(mediaIconImageView)

        rightBottomHorStackView = UIStackView()
        rightVertStackView.addArrangedSubview(rightBottomHorStackView)

        rewardLabel = UILabel()
        rightBottomHorStackView.addArrangedSubview(rewardLabel)

        rewardIconImageView = UIImageView()
        rightBottomHorStackView.addArrangedSubview(rewardIconImageView)
    }

    private func dataDidChange(from oldData: Data?) {
        viewData = state?.data.viewData

        statusImageView.image = Stub.image(withSize: .init(width: 200, height: 200))

        nameLabel.text = state?.data.item.name
        statusLabel.text = state?.data.formattedStatus

        mediaCountLabel.text = state?.data.formattedMediaCount
        mediaIconImageView.image = Stub.image(withSize: .init(width: 100, height: 100))

        rewardLabel.text = state?.data.formattedReward
        rewardIconImageView.image = Stub.image(withSize: .init(width: 100, height: 100))
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
            $0.edges.equalTo(contentView.layoutMarginsGuide)
        }
    }
}

extension ChallengeSearchItemCollectionViewCell {
    public struct State: StateType {
        var data: Data
        var layout: Layout = .init()
        var appearance: Appearance = .init()
    }

    public struct Data: StateType {
        var viewData: UIView.Data = .make()
        var item: ChallengeSearchItem
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

extension ChallengeSearchItemCollectionViewCell.Data {
    var formattedStatus: String {
        String("\(item.status)".prefix(10))
    }

    var formattedMediaCount: String {
        String("\(item.mediaCount)".prefix(10))
    }

    var formattedReward: String {
        String("\(item.reward)".prefix(10))
    }
}
