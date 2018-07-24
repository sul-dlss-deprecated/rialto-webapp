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
}
