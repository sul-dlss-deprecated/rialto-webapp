import { expect } from 'chai'
import Vue from 'vue'
import CrossDisciplinaryReport from 'rialto/layouts/crossDisciplinaryReport'

const vm = new Vue(CrossDisciplinaryReport).$mount()

describe('CrossDisciplinaryReport', () => {
  describe('reportURL', () => {
    it("is a url when all concepts are selected", () => {
        vm.picked = 'all'
        expect(vm.reportURL).to.equal('/reports/cross-disciplinary.csv')
    })
    it("is null when concept is not selected", () => {
      vm.picked = 'part'
      expect(vm.reportURL).to.be.null
    })
    it("is a url when the concept is selected", () => {
      vm.selectedConcept = { uri: "123" }
      vm.picked = 'part'
      expect(vm.reportURL).to.equal('/reports/cross-disciplinary.csv?concept_uri=123')
    })
  })
})
