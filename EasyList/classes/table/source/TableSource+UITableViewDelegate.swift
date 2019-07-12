//
//  Source+UITableViewDelegate.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 19/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

extension TableSource: UITableViewDelegate {
    
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
        let identifiedRow = getRow(indexPath: indexPath)
        return identifiedRow?.row.rowHeight?() ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let identifiedRow = getRow(indexPath: indexPath)
        return identifiedRow?.row.estimatedRowHeight?() ?? CGFloat(40)
    }
    
    //MARK: - Header rendering delegate
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = getHeader(index: section) {
            header.delegate?.willDisplayHeaderView?(tableView, willDisplayHeaderView: view, forSection: section)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let header = getHeader(index: section) {
            header.delegate?.didEndDisplayHeaderView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
        }
    }
    
    
    
    //MARK: - Footer render delegate
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footer = getFooter(index: section) {
            footer.delegate?.willDisplayFooterView?(tableView, willDisplayFooterView: view, forSection: section)
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let footer = getFooter(index: section) {
            footer.delegate?.didEndDisplayFooterView?(tableView, didEndDisplayingFooterView: view, forSection: section)
        }
    }
    
    //MARK: - Row render delegate
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.willDisplayRow?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.didEndDisplayRow?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
        self.getRow(indexPath: indexPath)?.row.resetCell()
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
        let identifiedRow = getRow(indexPath: indexPath)
        return identifiedRow?.row.willSelect?(index: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let identifiedRow = getRow(indexPath: indexPath)
        return identifiedRow?.row.willDeselect?(index: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifiedRow = getRow(indexPath: indexPath)
        identifiedRow?.row.didSelect?(index: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let identifiedRow = getRow(indexPath: indexPath)
        identifiedRow?.row.didDeselect?(index: indexPath)
    }
    
    //MARK: - Edition
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let identifiedRow = getRow(indexPath: indexPath)
        return identifiedRow?.row.getEditingStyle?() ?? .none
    }
    
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let identifiedRow = getRow(indexPath: indexPath)
        return identifiedRow?.row.getTitleForDeleteConfirmation?()
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
    
    // MARK: - ScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidZoom?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)  {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return delegate?.viewForZooming?(in: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return delegate?.scrollViewShouldScrollToTop?(scrollView) ?? false
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    @available(iOS 11.0, *)
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
}
