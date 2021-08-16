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
        contentView.applying {
            $0.layoutMargins = .zero
        }

        horStackView = UIStackView().applying {
            $0.alignment = .center
            $0.spacing = 16
        }
        contentView.addSubview(horStackView)

        statusImageView = UIImageView()
        horStackView.addArrangedSubview(statusImageView)

        centralVertStackView = UIStackView().applying {
            $0.axis = .vertical
        }
        horStackView.addArrangedSubview(centralVertStackView)

        nameLabel = UILabel().applying {
            $0.font = .regular(withSize: 12)
            $0.textColor = .fullBlack
        }
        centralVertStackView.addArrangedSubview(nameLabel)

        statusLabel = UILabel().applying {
            $0.font = .regular(withSize: 12)
            $0.textColor = .grey_70
        }
        centralVertStackView.addArrangedSubview(statusLabel)

        rightVertStackView = UIStackView().applying {
            $0.axis = .vertical
            $0.alignment = .trailing
            $0.spacing = 6
        }
        horStackView.addArrangedSubview(rightVertStackView)

        rightTopHorStackView = UIStackView().applying {
            $0.spacing = 8
        }
        rightVertStackView.addArrangedSubview(rightTopHorStackView)

        mediaCountLabel = UILabel().applying {
            $0.font = .regular(withSize: 12)
            $0.textColor = .fullBlack
        }
        rightTopHorStackView.addArrangedSubview(mediaCountLabel)

        mediaIconImageView = UIImageView().applying {
            $0.image = UIImage(named: "icon-basic-media", in: .module, with: nil)
        }
        rightTopHorStackView.addArrangedSubview(mediaIconImageView)

        rightBottomHorStackView = UIStackView().applying {
            $0.spacing = 8
        }
        rightVertStackView.addArrangedSubview(rightBottomHorStackView)

        rewardLabel = UILabel().applying {
            $0.font = .regular(withSize: 12)
            $0.textColor = .fullBlack
        }
        rightBottomHorStackView.addArrangedSubview(rewardLabel)

        rewardIconImageView = UIImageView().applying {
            $0.image = UIImage(named: "icon-basic-reward", in: .module, with: nil)
        }
        rightBottomHorStackView.addArrangedSubview(rewardIconImageView)
    }

    private func dataDidChange(from oldData: Data?) {
        viewData = state?.data.viewData

        statusImageView.image = {
            switch state?.data.item.status {
            case nil:
                return nil
            case .created:
                return UIImage(named: "icon-challenge-future", in: .module, with: nil)
            case .active:
                return UIImage(named: "icon-challenge-active", in: .module, with: nil)
            case .completed:
                return UIImage(named: "icon-challenge-completed", in: .module, with: nil)
            }
        }()

        nameLabel.text = state?.data.item.name
        statusLabel.text = state?.data.formattedStatus

        mediaCountLabel.text = state?.data.formattedMediaCount

        rewardLabel.text = state?.data.formattedReward
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

        statusImageView.snp.updateConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }

        mediaIconImageView.snp.updateConstraints {
            $0.size.equalTo(CGSize(width: 16, height: 16))
        }

        rewardIconImageView.snp.updateConstraints {
            $0.size.equalTo(CGSize(width: 16, height: 16))
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
