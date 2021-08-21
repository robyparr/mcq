import { Controller } from 'stimulus'
import _capitalize from 'lodash/capitalize'

export default class extends Controller {
  static targets = [
    'hidden',
    'text',
    'option',
  ]

  static values = {
    defaultLabel: String,
  }

  select(e) {
    const selectedValue = e.target.dataset.filterValue
    const selectedLabel = e.target.dataset.filterLabel

    this.hiddenTarget.value = selectedValue
    this.setTextValue(selectedLabel)
  }

  setTextValue(value) {
    let capitalizedValue = value ? _capitalize(value) : _capitalize(this.defaultLabelValue)
    this.textTarget.innerText = capitalizedValue
  }
}
