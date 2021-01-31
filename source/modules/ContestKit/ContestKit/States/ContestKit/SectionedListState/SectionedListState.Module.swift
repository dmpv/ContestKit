//
//  SectionedListState.Module.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation
import UIKit

public class SectionedListModule: NSObject {
    private let store: RDXKit.Store<SectionedListState>

    private(set) var tableView: UITableView!

    public init(store: RDXKit.Store<SectionedListState>) {
        self.store = store
        super.init()
        setup()
    }

    private func setup() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
    }

    public var view: SectionedListView {
        let view = SectionedListView(module: self)
        _ = store.stateObservable
            .addObserver { [weak view] state in
                view?.state = state.view
            }
        return view
    }
}

extension SectionedListModule {
    fileprivate func willDisplay(cell: RowCell, for rowID: RowID) {
        let rowModule = RowModule(store: store.rowStore(for: rowID))
        rowModule.setup(cell: cell)
        cell.module = rowModule
    }

    fileprivate func didEndDisplaying(cell: RowCell, for rowID: RowID) {
        cell.module = nil
    }

    fileprivate func title(for sectionID: SectionID) -> String? {
        switch sectionID {
        case .messageAnimations:
            return L10n.stub("Messages")
        case .backgroundAnimation:
            return L10n.stub("Other")
        case .common:
            return nil
        case .timing(let messageAnimationTimingID):
            return messageAnimationTimingID.editorSectionTitle
        }
    }

    fileprivate func height(for rowID: RowID) -> CGFloat {
        switch rowID {
        case .picker,
             .button:
            return 44
        case .animationTiming:
            return 212
        }
    }

    fileprivate func row(at indexPath: IndexPath) -> RowState {
        section(at: indexPath.section).rows[indexPath.row]
    }

    fileprivate func section(at index: Int) -> SectionState {
        store.state.sections[index]
    }

    fileprivate func reusableID(for rowID: RowID) -> String {
        switch rowID {
        case .picker:
            return "\(PickerCell.self)"
        case .button:
            return "\(ButtonCell.self)"
        case .animationTiming:
            return "\(AnimationTimingCell.self)"
        }
    }

    fileprivate func registerCell(for rowID: RowID) {
        tableView.register(
            {
                switch rowID {
                case .picker:
                    return PickerCell.self
                case .button:
                    return ButtonCell.self
                case .animationTiming:
                    return AnimationTimingCell.self
                }
            }() as AnyClass,
            forCellReuseIdentifier: reusableID(for: rowID)
        )
    }

    fileprivate func dequeueCell(for rowID: RowID) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reusableID(for: rowID))
        else {
            registerCell(for: rowID)
            return dequeueCell(for: rowID)
        }

        switch (rowID, cell) {
        case (.picker, let pickerCell as PickerCell):
            return pickerCell
        case (.button, let buttonCell as ButtonCell):
            return buttonCell
        case (.animationTiming, let animationTimingCell as AnimationTimingCell):
            return animationTimingCell
        default:
            fatalError(.shouldNeverBeCalled())
        }
    }
}

extension SectionedListModule: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplay(cell: cell as! RowCell, for: row(at: indexPath).id)
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        didEndDisplaying(cell: cell as! RowCell, for: row(at: indexPath).id)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        title(for: self.section(at: section).id)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        height(for: row(at: indexPath).id)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SectionedListModule: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        store.state.sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.state.sections[section].rows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dequeueCell(for: row(at: indexPath).id)
    }
}
