import { expect } from 'chai'
import Result from 'blacklight/search/result'

describe('Result', () => {
  describe('.filters', () => {
    it("is empty by default", () => {
      const result = new Result({
        meta: {pages: {}}, links: {}, included: []
      })
      expect(result.filters).to.be.empty
    })

    it("has filters", () => {
      const result = new Result({
        meta: { pages: {} },
        links: {},
        "included": [{
          "type": "facet",
          "id": "type_ssi",
          "attributes": {
            "label": "Type",
            "items": [{
              "attributes": {
                "label": "Person",
                "value": "Person",
                "hits": 105757
              },
              "links": {
                "remove": "/?q="
              }
            },
            {
              "attributes": {
                "label": "Organization",
                "value": "Organization",
                "hits": 300
              },
              "links": {}
            }]
          },
          "links": {
            "self": "http://localhost:3000/catalog/facet/type_ssi.json?f%5Btype_ssi%5D%5B%5D=Person\u0026q="
          }
        }, {
          "type": "facet",
          "id": "school_label_ssim",
          "attributes": {
            "label": "School",
            "items": [{
              "attributes": {
                "label": "School of Medicine",
                "value": "School of Medicine",
                "hits": 17901
              },
              "links": {
                "self": "http://localhost:3000/catalog.json?f%5Bschool_label_ssim%5D%5B%5D=School+of+Medicine\u0026f%5Btype_ssi%5D%5B%5D=Person\u0026q="
              }
            }]
          }
        }]
      })
      expect(result.filters).to.deep.eq([{ field: "Type", value: "Person", link: "/?q=" }])
    })
  })
})
