import { expect } from 'chai'
import Vue from 'vue'
import PropertyList from 'blacklight/result/property_list'

// helper function that mounts and returns the rendered text
function getFilteredAttributes (document) {
  const Constructor = Vue.extend(PropertyList)
  return new Constructor({ propsData: { item: document } }).filteredAttributes
}

describe('filterAttributes', () => {
  it("ignores name_tsim when present", () => {
    var document = {
      attributes: {
        name_tsim: {
          attributes: {
            value: 'Jim'
          }
        },
        title_tesi: {
            attributes: {
                value: 'My Life with the Thrill Kill Kult'
            }
        },
        foo: {
          attributes: {
            value: 'Bar'
          }
        }

      }
    }
    var filteredAttributes = getFilteredAttributes(document);
    expect(filteredAttributes).to.have.all.keys('foo');
    expect(filteredAttributes).not.to.have.any.keys('name_tsim', 'title_tesi');
  })
})
