import { expect } from 'chai'
import Vue from 'vue'
import VueResource from  'vue-resource'
Vue.use(VueResource)
import Reports from '../blacklight/layouts/reports.vue'

const MockMiddleware = () => {
  return (request, next) => {
      next(request.respondWith('', ''))
  }
}
Vue.http.interceptors.push(MockMiddleware())

const vm = new Vue(Reports).$mount()

describe('reportURL', () => {
  it("is null when department is not selected", () => {
    expect(vm.reportURL).to.be.null
  })

  it("is a url when the department is selected", () => {
    vm.selectedDepartment = { id: "123" }
    expect(vm.reportURL).to.equal('/reports/coauthors.csv?department_id=123')
  })
})
