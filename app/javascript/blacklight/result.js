export default class {
  constructor(json) {
    if (typeof(json) === 'undefined')
      json = {meta: {pages: {}}, links: {}}
    this.json = json
    // console.log(json)
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

  get included() {
    return this.json.included
  }
}
