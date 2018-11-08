import { expect } from 'chai'
import Vue from 'vue'
import CrossDisciplinaryReport from '../blacklight/layouts/crossDisciplinaryReport.vue'

const vm = new Vue(CrossDisciplinaryReport).$mount()

describe('CrossDisciplinaryReport', () => {
  describe('reportURL', () => {
    it("is null when concept is not selected", () => {
      expect(vm.reportURL).to.be.null
    })

    it("is a url when the department is selected", () => {
      vm.selectedConcept = { uri: "123" }
      expect(vm.reportURL).to.equal('/reports/cross-disciplinary.csv?concept_uri=123')
    })
  })
})
