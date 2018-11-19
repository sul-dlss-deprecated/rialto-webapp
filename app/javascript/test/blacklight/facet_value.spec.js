import { expect } from 'chai'
import { shallowMount } from '@vue/test-utils'
import Value from 'blacklight/facet/value'

describe('facet_value', () => {
  it("shows the localized value", () => {
    const value = {
      attributes: {
        hits: 33213
      },
      links: {
        remove: ''
      }
    }
    const wrapper = shallowMount(Value, {
      propsData: {
        value: value,
        size: 5
      }
    })

    expect(wrapper.vm.count).to.eq('33,213')
    expect(wrapper.vm.style).to.eq('width: 6ch')

  })
})
