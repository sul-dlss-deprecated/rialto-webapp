// Polyfills
import flatMap from 'array.prototype.flatmap'

export default class {
  constructor(json) {
    if (typeof(json) === 'undefined')
      json = {meta: {pages: {}}, links: {}, included: []}
    this.json = json
  }

  get links() {
    return this.json.links
  }

  get meta() {
    return this.json.meta
  }

  get data() {
    return this.json.data
  }

  get facets() {
    return this.json.included.filter(item => item.type == 'facet')
  }

  // Return a list of facets and the list to remove them
  get filters() {
    var facetsWithRemove = this.facets.filter(facet => {
      return facet.attributes.items.some(facetItem => {
        return 'remove' in facetItem.links
      })
    })
    return flatMap(facetsWithRemove, field => {
      var attr = field.attributes
      return attr.items.map(item => { return { field: attr.label, value: item.attributes.label, link: item.links.remove } })
    })
  }
}
