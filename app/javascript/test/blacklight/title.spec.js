import { expect } from 'chai'
import Vue from 'vue'
import Title from 'blacklight/result/title'

// helper function that mounts and returns the rendered text
function getTitle (document) {
  const Constructor = Vue.extend(Title)
  return new Constructor({ propsData: { item: document } }).title
}

describe('title', () => {
  it("renders id when the document doesn't have a type", () => {
    var document = {
      id: '123',
      attributes: {}
    }
    expect(getTitle(document)).to.equal('123')
  })

  it("renders name_tsim when the document is a person", () => {
    var document = {
      id: '123',
      type: 'Person',
      attributes: {
        name_tsim: {
          attributes: {
            value: 'Jim'
          }
        }
      }
    }
    expect(getTitle(document)).to.equal('Jim')
  })

  it("renders title_tesi when the document is an organization", () => {
    var document = {
      id: '123',
      type: 'Organization',
      attributes: {
        title_tesi: {
          attributes: {
            value: 'Institute for Collaborative Computing'
          }
        }
      }
    }
    expect(getTitle(document)).to.equal('Institute for Collaborative Computing')
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
