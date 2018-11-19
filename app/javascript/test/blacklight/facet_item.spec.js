import { expect } from 'chai'
import { shallowMount } from '@vue/test-utils'
import Item from 'blacklight/facet/item'

describe('facet_item', () => {
  it("shows the localized value", () => {
    const item = {
      attributes: {
        label: 'Animal',
        items: [
          {
            id: 'frog',
            attributes: {
              hits: 3,
              label: 'Frog'
            }
          },
          {
            id: 'snakes',
            attributes: {
              hits: 89808,
              label: 'Snake'
            }
          },
          {
            id: 'toads',
            attributes: {
              hits: 200,
              label: 'Toad'
            }
          }
        ]
      }
    }
    const wrapper = shallowMount(Item, {
      propsData: {
        item: item
      }
    })

    expect(wrapper.vm.size).to.eq(5)
  })
})
