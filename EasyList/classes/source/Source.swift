//
//  Source.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 08/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

public class Source: NSObject, RowLayout, RowEdition, RowSelection {
    var sections: [BaseSection]
    public var delegate: SourceDelegate?
    public weak var tableView: TableView?
    
    public init(sections: [BaseSection] = [], tableView: TableView, delegate: SourceDelegate? = nil) {
        self.sections = sections
        self.tableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.tableView?.source = self
    }
    
    //MARK: - Section
    @discardableResult
    public func addSection(_ section: BaseSection) -> BaseSection {
        section.source = self
        sections.append(section)
        return section
    }
    
    private func getSection(index: Int) -> BaseSection {
        return sections[index]
    }
    
    //MARK: - Header
    private func getHeader(index: Int) -> BaseHeader? {
        return getSection(index: index).getHeader()
    }
    
    //MARK: - Footer
    private func getFooter(index: Int) -> BaseFooter? {
        return getSection(index: index).getFooter()
    }
    
    //MARK: - Row
    private func getRow(indexPath: IndexPath) -> RowType {
        return getSection(index: indexPath.section).getRow(at: indexPath.row)
    }
    
    @discardableResult
    public func insertRow(_ row: RowType, at index: IndexPath, animation: UITableView.RowAnimation = .automatic) -> Source {
        let section = getSection(index: index.section)
        section.addRow(row)
        tableView?.insertRows(at: [index], with: animation)
        return self
    }
    
    //MARK: - RowLayout
    var _height: (() -> CGFloat)?
    @discardableResult
    public func setRowHeight(_ height: (() -> CGFloat)?) -> Source {
        _height = height
        return self
    }
    
    var _estimatedHeight: (() -> CGFloat)?
    @discardableResult
    public func setEstimatedRowHeight(_ estimatedHeight: (() -> CGFloat)?) -> Source {
        _estimatedHeight = estimatedHeight
        return self
    }
    
    //MARK: - RowEdition
    var _editable: (() -> Bool)?
    var _editingStyle: (() -> UITableViewCell.EditingStyle)?
    var _titleForDeleteConfirmation: (() -> String?)?
    @discardableResult
    public func setRowEditable(editable: (() -> Bool)?, editingStyle: (() -> UITableViewCell.EditingStyle)? = {return .delete}, titleForDeleteConfirmation: (() -> String?)? = nil) -> Source {
        _editable = editable
        _editingStyle = editingStyle
        _titleForDeleteConfirmation = titleForDeleteConfirmation
        return self
    }
    
    //MARK: - RowSelection
    var _willSelect: ((_ index: IndexPath) -> IndexPath)?
    @discardableResult
    public func setWillSelect(_ willSelect: ((_ index: IndexPath) -> IndexPath)?) -> Source {
        _willSelect = willSelect
        return self
    }
    
    var _didSelect: ((_ index: IndexPath) -> Void)?
    @discardableResult
    public func setDidSelect(_ didSelect: ((_ index: IndexPath) -> Void)?) -> Source {
        _didSelect = didSelect
        return self
    }
    
    var _willDeselect: ((_ index: IndexPath) -> IndexPath)?
    @discardableResult
    public func setWillDeselect(_ willDeselect: ((_ index: IndexPath) -> IndexPath)?) -> Source {
        _willDeselect = willDeselect
        return self
    }
    
    var _didDeselect: ((_ index: IndexPath) -> Void)?
    @discardableResult
    public func setDidDeselect(_ didDeselect: ((_ index: IndexPath) -> Void)?) -> Source {
        _didDeselect = didDeselect
        return self
    }
}

extension Source: UITableViewDataSource {
    
    //MARK: - Section
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSection(index: section).rowCount()
    }
    
    //MARK: - Header
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = getHeader(index: section)
        
        if header is NativeHeader {
            return (header as! NativeHeader).title
        }
        
        return nil
    }
    
    //MARK: - Footer
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let footer = getFooter(index: section)
        
        if footer is NativeFooter {
            return (footer as! NativeFooter).title
        }
        
        return nil
    }
    
    //MARK: - Row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = getRow(indexPath: indexPath)
        
        let cell = row.getCell(tableView: tableView)
        
        return cell
    }
    
    //MARK: - Edit row
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = getRow(indexPath: indexPath)
        return row.isEditable?() ?? false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        delegate?.editingStyle?(editingStyle: editingStyle, at: indexPath, for: tableView)
    }
    
    //MARK: - Move row
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return delegate?.canMoveRow?(at: indexPath, for: tableView) ?? false
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.moveRowAt?(sourceIndexPath: sourceIndexPath, to: destinationIndexPath, for: tableView)
    }
    
    //MARK: - Section Titles
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return delegate?.sectionIndexTitles?(for: tableView) ?? []
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return delegate?.sectionForSectionIndexTitle?(for: tableView, title: title, at: index)  ?? 0
    }
}

extension Source: UITableViewDelegate {
    
    //MARK: - Header Layout
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let header = getHeader(index: section) {
            return (header as HeaderLayout).headerHeight?() ?? UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if let header = getHeader(index: section) {
            return (header as HeaderLayout).headerEstimatedHeight?() ?? CGFloat(40)
        }
        return CGFloat(0)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = getHeader(index: section)
        return header is NativeHeader ? nil : header
    }
    
    //MARK: - Footer Layout
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footer = getFooter(index: section) {
            return (footer as FooterLayout).footerHeight?() ?? UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if let footer = getFooter(index: section) {
            return (footer as FooterLayout).footerEstimatedHeight?() ?? CGFloat(40)
        }
        return CGFloat(0)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = getFooter(index: section)
        return footer is NativeFooter ? nil : footer
    }
    
    //MARK: - Cell layout
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = getRow(indexPath: indexPath)
        return row.rowHeight?() ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = getRow(indexPath: indexPath)
        return row.estimatedRowHeight?() ?? CGFloat(40)
    }
    
    //MARK: - Header rendering delegate
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = getHeader(index: section) {
            (header as HeaderDelegate).willDisplayHeaderView?(tableView, willDisplayHeaderView: view, forSection: section)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let header = getHeader(index: section) {
            (header as HeaderDelegate).didEndDisplayHeaderView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
        }
    }
    
    
    
    //MARK: - Footer render delegate
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footer = getFooter(index: section) {
            (footer as FooterDelegate).willDisplayFooterView?(tableView, willDisplayFooterView: view, forSection: section)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let footer = getFooter(index: section) {
            (footer as FooterDelegate).didEndDisplayFooterView?(tableView, didEndDisplayingFooterView: view, forSection: section)
        }
    }
    
    //MARK: - Row render delegate
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.willDisplayRow?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.didEndDisplayRow?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    //MARK: - Accessory
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        delegate?.accessoryButtonTappedForRowWith?(tableView, accessoryButtonTappedForRowWith: indexPath)
    }
    
    
    
    
    
    
    //MARK: - Highlight
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return delegate?.shouldHighlightRowAt?(tableView, shouldHighlightRowAt: indexPath) ?? true
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        delegate?.didHighlightRowAt?(tableView, didHighlightRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        delegate?.didUnhighlightRowAt?(tableView, didUnhighlightRowAt: indexPath)
    }
    
    
    
    //MARK: - Selection
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let row = getRow(indexPath: indexPath)
        return row.willSelect?(index: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let row = getRow(indexPath: indexPath)
        return row.willDeselect?(index: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = getRow(indexPath: indexPath)
        row.didSelect?(index: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let row = getRow(indexPath: indexPath)
        row.didDeselect?(index: indexPath)
    }
    
    //MARK: - Edition
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let row = getRow(indexPath: indexPath)
        return row.getEditingStyle?() ?? .none
    }
    
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let row = getRow(indexPath: indexPath)
        return row.getTitleForDeleteConfirmation?()
    }
    
    
    
    
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return delegate?.editActionsForRowAt?(tableView, editActionsForRowAt: indexPath)
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return delegate?.leadingSwipeActionsConfigurationForRowAt?(tableView, leadingSwipeActionsConfigurationForRowAt: indexPath)
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return delegate?.trailingSwipeActionsConfigurationForRowAt?(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return delegate?.shouldIndentWhileEditingRowAt?(tableView, shouldIndentWhileEditingRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        delegate?.willBeginEditingRowAt?(tableView, willBeginEditingRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        delegate?.didEndEditingRowAt?(tableView, didEndEditingRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return delegate?.targetIndexPathForMoveFromRowAt?(tableView, targetIndexPathForMoveFromRowAt: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath) ?? proposedDestinationIndexPath
    }
    
    public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return delegate?.indentationLevelForRowAt?(tableView, indentationLevelForRowAt: indexPath) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return delegate?.shouldShowMenuForRowAt?(tableView, shouldShowMenuForRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return delegate?.canPerformActionForRowAt?(tableView, canPerformAction: action, forRowAt: indexPath, withSender: sender) ?? false
    }
    
    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        delegate?.performActionForRowAt?(tableView, performAction: action, forRowAt: indexPath, withSender: sender)
    }
    
    
    
    //MARK: - Focus
    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return delegate?.canFocusRowAt?(tableView, canFocusRowAt: indexPath) ?? true
    }
    
    public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return delegate?.shouldUpdateFocusIn?(tableView, shouldUpdateFocusIn: context) ?? true
    }
    
    public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        delegate?.didUpdateFocusIn?(tableView, didUpdateFocusIn: context, with: coordinator)
    }
    
    public func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return delegate?.indexPathForPreferredFocusedView?(in: tableView)
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return delegate?.shouldSpringLoadRowAt?(tableView, shouldSpringLoadRowAt: indexPath, with: context) ?? false
    }
}

@objc public protocol SourceDelegate {
    @objc optional func canMoveRow(at: IndexPath, for tableView: UITableView) -> Bool
    @objc optional func sectionIndexTitles(for tableView: UITableView) -> [String]?
    @objc optional func sectionForSectionIndexTitle(for tableView: UITableView, title: String, at index: Int) -> Int
    @objc optional func editingStyle(editingStyle: UITableViewCell.EditingStyle, at index: IndexPath, for: UITableView)
    @objc optional func moveRowAt(sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, for tableView: UITableView)
    
    @objc optional func willDisplayRow(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    @objc optional func didEndDisplayRow(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    
    @objc optional func accessoryButtonTappedForRowWith(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    @objc optional func shouldHighlightRowAt(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    @objc optional func didHighlightRowAt(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    @objc optional func didUnhighlightRowAt(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    
    @objc optional func willSelectRowAt(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    @objc optional func willDeselectRowAt(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
    @objc optional func didSelectRowAt(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func didDeselectRowAt(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    
    @objc optional func editActionsForRowAt(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    @available(iOS 11.0, *)
    @objc optional func leadingSwipeActionsConfigurationForRowAt(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    @available(iOS 11.0, *)
    @objc optional func trailingSwipeActionsConfigurationForRowAt(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    @objc optional func shouldIndentWhileEditingRowAt(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    @objc optional func willBeginEditingRowAt(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
    @objc optional func didEndEditingRowAt(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
    @objc optional func targetIndexPathForMoveFromRowAt(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    @objc optional func indentationLevelForRowAt(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
    @objc optional func shouldShowMenuForRowAt(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool
    @objc optional func canPerformActionForRowAt(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool
    @objc optional func performActionForRowAt(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)
    @objc optional func canFocusRowAt(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
    @objc optional func shouldUpdateFocusIn(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool
    @objc optional func didUpdateFocusIn(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
    @objc optional func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
    @available(iOS 11.0, *)
    @objc optional func shouldSpringLoadRowAt(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool
}
