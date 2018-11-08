<template>
  <section class="container">
    <h1>Research Trends Report</h1>
    <label for="school">School: </label>
    <select name="school" v-model="selectedSchool" @change="selectedDepartment=''">
      <option v-for="school in schools" :value="school">{{ school.label }}</option>
    </select><br />
    <label for="department">Department: </label>
    <select name="department" v-model="selectedDepartment" @change="selectedSchool=''">
      <option v-for="department in departments" :value="department">{{ department.label }}</option>
    </select><br />
    <label for="yearsRange">Years: </label>
    <YearSlider v-model="selectedYearsRange"></YearSlider>
    <ul v-if="reportURL">
      <li><a href="#" v-on:click="download">Download</a></li>
    </ul>
    <ReportTable v-bind:data-source="reportURL"></ReportTable>
  </section>
</template>


<script>
import ReportTable from 'blacklight/reports/table.vue'
import YearSlider from '../reports/yearSlider'

export default {
  components: {
    ReportTable,
    YearSlider
  },
  data: function () {
    return {
      selectedSchool: '',
      schools: [],
      selectedDepartment: '',
      departments: [],
      selectedYearsRange: [2000, (new Date()).getFullYear()]
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
      if (!(this.selectedSchool || this.selectedDepartment)) {
          return null
      }
      return `/reports/research-trends.csv?org_uri=${this.selectedDepartment.uri || this.selectedSchool.uri}&start_year=${this.selectedYearsRange[0]}&end_year=${this.selectedYearsRange[1]}`
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
