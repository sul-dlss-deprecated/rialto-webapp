<template>
  <section class="container">
    <h1>Collaboration Report</h1>
    <label for="school">School: </label>
    <select name="school" v-model="selectedSchool" @change="selectedDepartment=''">
      <option v-for="school in schools" :value="school">{{ school.label }}</option>
    </select><br />
    <label for="department">Department: </label>
    <select name="department" v-model="selectedDepartment" @change="selectedSchool=''">
      <option v-for="department in departments" :value="department">{{ department.label }}</option>
    </select><br />
    <label for="reportType">Report type: </label>
    <select name="reportType" v-model="selectedReportType">
        <option value="coauthors">Co-authors</option>
        <option value="coauthor-institutions">Co-author institutions</option>
        <option value="coauthor-countries">Co-author countries</option>
    </select><br />
    <label for="yearsRange">Years: </label>
    <vue-slider name="yearsRange" v-model="selectedYearsRange" :min=minYear :max=maxYear width="80%"></vue-slider><br />
    <ul v-if="reportURL">
      <li><a href="#" v-on:click="download">Download</a></li>
    </ul>
    <div v-show="selectedReportType === 'coauthor-countries'">
      <Choropleth v-bind:reportURL="reportURL"/><br />
    </div>
    <ReportTable v-bind:data-source="reportURL"></ReportTable>
  </section>
</template>


<script>
import ReportTable from 'blacklight/reports/table.vue'
import Choropleth from '../choropleth.vue'
import vueSlider from 'vue-slider-component';

export default {
  components: {
    ReportTable,
    Choropleth,
    vueSlider
  },
  data: function () {
    const thisYear = (new Date()).getFullYear();
    return {
      selectedSchool: '',
      schools: [],
      selectedDepartment: '',
      departments: [],
      selectedReportType: 'coauthors',
      selectedYearsRange: [2000, thisYear],
      minYear: 2000,
      maxYear: thisYear
    }
  },
  created() {
    var result = this.$http.get('/schools').then(function(response){
        this.schools = response.data
    }, function(error){
        console.error(error.statusText);
    })
    var result = this.$http.get('/departments').then(function(response){
        this.departments = response.data
    }, function(error){
        console.error(error.statusText);
    })
  },
  computed: {
    reportURL: function(){
      // Must have a report type
      if (!this.selectedReportType || !(this.selectedSchool || this.selectedDepartment)) {
          return null
      }
      return `/reports/${this.selectedReportType}.csv?org_uri=${this.selectedDepartment.uri || this.selectedSchool.uri}&start_year=${this.selectedYearsRange[0]}&end_year=${this.selectedYearsRange[1]}`
    }
  },
  methods: {
    download: function() {
      window.location = this.reportURL
    }
  }
}
</script>

<style scoped>
</style>
