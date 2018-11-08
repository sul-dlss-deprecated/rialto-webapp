import { expect } from 'chai'
import Vue from 'vue'
import ResearchTrendsReport from '../blacklight/layouts/research_trends_report.vue'

const vm = new Vue(ResearchTrendsReport).$mount()

describe('ResearchTrendsReport', () => {
  describe('reportURL', () => {
    it("is null when department is not selected", () => {
      expect(vm.reportURL).to.be.null
    })

    it("is a url when the department is selected", () => {
      var currentYear = (new Date()).getFullYear()
      vm.selectedDepartment = { uri: "123" }
      expect(vm.reportURL).to.equal(`/reports/research-trends.csv?org_uri=123&start_year=2000&end_year=${currentYear}`)
    })
  })
})
