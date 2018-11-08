import { expect } from 'chai'
import Vue from 'vue'
import VueResource from  'vue-resource'
Vue.use(VueResource)
import CollaborationReport from '../blacklight/layouts/collaboration_report.vue'

const MockMiddleware = () => {
  return (request, next) => {
      next(request.respondWith('', ''))
  }
}
Vue.http.interceptors.push(MockMiddleware())

const vm = new Vue(CollaborationReport).$mount()
describe('CollaborationReport', () => {
  describe('reportURL', () => {
    it("is null when department is not selected", () => {
      expect(vm.reportURL).to.be.null
    })

    it("is a url when the department is selected", () => {
      var currentYear = (new Date()).getFullYear()
      vm.selectedDepartment = { uri: "123" }
      expect(vm.reportURL).to.equal(`/reports/coauthors.csv?org_uri=123&start_year=2000&end_year=${currentYear}`)
    })
  })
})
