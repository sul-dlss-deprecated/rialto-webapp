import { expect } from 'chai'
import Vue from 'vue'
import Item from '../blacklight/result/item.vue'

// helper function that mounts and returns the rendered text
function getTitle (document) {
  const Constructor = Vue.extend(Item)
  return new Constructor({ propsData: { item: document } }).title
}

describe('title', () => {
  it("renders id when the document doesn't have a type", () => {
    var document = {
      id: '123'
    }
    expect(getTitle(document)).to.equal('123')
  })

  it("renders name_ssim when the document is a person", () => {
    var document = {
      id: '123',
      type: 'http://xmlns.com/foaf/0.1/Person',
      attributes: {
        name_ssim: {
          attributes: {
            value: 'Jim'
          }
        }
      }
    }
    expect(getTitle(document)).to.equal('Jim')
  })

  it("renders name_ssim when the document is an organization", () => {
    var document = {
      id: '123',
      type: 'http://xmlns.com/foaf/0.1/Organization',
      attributes: {
        name_ssim: {
          attributes: {
            value: 'Jim'
          }
        }
      }
    }
    expect(getTitle(document)).to.equal('Jim')
  })

  it("renders title_tesi when the document is not an Agent", () => {
    var document = {
      id: '123',
      type: 'http://vivoweb.org/ontology/core#Grant',
      attributes: {
        title_tesi: {
          attributes: {
            value: 'Rialto'
          }
        }
      }
    }
    expect(getTitle(document)).to.equal('Rialto')
  })
})
