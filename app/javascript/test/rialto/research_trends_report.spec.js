import { expect } from 'chai'
import Vue from 'vue'
import ResearchTrendsReport from 'rialto/layouts/researchTrendsReport'

const vm = new Vue(ResearchTrendsReport).$mount()

describe('ResearchTrendsReport', () => {
  describe('reportURL', () => {
    it("is null when department is not selected", () => {
      expect(vm.reportURL).to.be.null
    })

    it("is a url when the department is selected", () => {
      var currentYear = (new Date()).getFullYear()
      vm.selectedDepartment = { uri: "123" }
      expect(vm.reportURL).to.equal(`/reports/research-trends.csv?start_year=${currentYear-10}&end_year=${currentYear}&org_uri=123`)
    })
  })
  describe('loadDepartmentsUrl', () => {
      it("does not include school when school not selected", () => {
          expect(vm.loadDepartmentsUrl()).to.equal(`/departments`)
      })

      it("includes school when school is selected", () => {
          vm.selectedSchool = { uri: "123"}
          expect(vm.loadDepartmentsUrl()).to.equal(`/departments?parent_school=123`)
      })
  })
})
