import { Controller } from 'stimulus'
import Utils from '../src/utils'

export default class extends Controller {
  static targets = [
    'action',
    'item',
  ]

  connect() {
    this.updateSelectedItems()
  }

  allItemsChanged(e) {
    let shouldSelectAll = e.target.checked

    this.itemTargets.forEach(item => item.checked = shouldSelectAll)
    this.updateSelectedItems()
  }

  itemChanged() {
    this.updateSelectedItems()
  }

  trigger(e) {
    if (e.target.value == 'null' || !this.actionConfirmedIfRequired(e.target))
      return

    let ids            = e.target.dataset.ids
    let url            = e.target.dataset.url
    let valueParamName = e.target.dataset.valueParamName
    let method         = e.target.dataset.method

    let body = { ids: ids }
    if (e.target.value)
      body[valueParamName] = e.target.value

    Utils.fetch(
      url,
      {
        method: method || 'PUT',
        body: body,
      }
    )
  }

  updateSelectedItems() {
    let selectedItems =
      this.itemTargets
          .filter(item => item.checked)
          .map(item => item.value)
    let selectedItemsString = selectedItems.join(',')

    this.actionTargets
        .forEach(target => target.dataset.ids = selectedItemsString)

    if (selectedItems.length > 0) {
      this.enableActions()
    } else {
      this.disableActions()
    }
  }

  disableActions() {
    this.actionTargets.forEach(action => action.disabled = true)
  }

  enableActions() {
    this.actionTargets.forEach(action => action.disabled = false)
  }

  actionConfirmedIfRequired(target) {
    let confirmed = true
    if (target.dataset.confirmAction) {
      confirmed = confirm(target.dataset.confirmAction)
    }

    return confirmed
  }
}
