//
//  PickerCell.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation
import UIKit

final class PickerCell: UITableViewCell, RowCell {
    var state: State? {
        didSet { stateDidChange(from: oldValue) }
    }

    var handlers = Handlers() {
        didSet { handlersDidChange() }
    }

    var module: RowModule?

    private var activated = false
    private var currentLayout: Layout?

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setup()
        activate()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func activate() {
        guard !activated else { return fallback() }
        stateDidChange(from: state)
        updateConstraints()
        activated = true
    }

    private func setup() {
        accessoryType = .disclosureIndicator
    }

    private func stateDidChange(from oldState: State?) {
        guard state != oldState || !activated else { return }

        textLabel!.text = state?.name
        detailTextLabel?.text = state?.selectedOption

        layoutDidChange(from: oldState?.layout)
        appearanceDidChange(from: oldState?.appearance)
    }

    private func layoutDidChange(from oldLayout: Layout?) {
        guard state?.layout != oldLayout || !activated else { return }
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }

    private func appearanceDidChange(from oldAppearance: Appearance?) {
        guard state?.appearance != oldAppearance || !activated else { return }

        textLabel!.applying {
            $0.textColor = state?.appearance.textColor
        }
    }

    private func handlersDidChange() {
    }

    override func updateConstraints() {
        defer {
            currentLayout = state?.layout
            super.updateConstraints()
        }
        guard state?.layout != currentLayout || !activated else { return }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            handlers.onPress?()
        }
    }
}

extension PickerCell {
    struct State: Equatable {
        var name: String
        var selectedOption: String
        var layout = Layout()
        var appearance = Appearance()
    }

    struct Layout: Equatable {
    }

    struct Appearance: Equatable {
        var textColor: UIColor?
    }

    struct Handlers {
        var onPress: (() -> Void)?
    }
}
