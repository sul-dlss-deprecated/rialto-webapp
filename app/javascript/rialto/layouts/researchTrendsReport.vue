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
    <div class="alert alert-light">
      <p>This report aggregates publications by research topic and year, in order to show trends in research by
         topic area over time. You can filter by school, department and date of publication.</p>
    </div>
    <ReportTable v-bind:data-source="reportURL"></ReportTable>
    <div class="alert alert-light">
      <p>Topic area data for these reports are pulled from publications in the Web of Science, a Clarivate product. Note
         that Clarivate categorizes publications into topic area at the level of a journal (not individual
         publications). Note that some limits of this report include:
        <ul>
          <li>not all publications are represented in the Web of Science, and coverage by subject area will vary</li>
          <li>only publications from authors currently at Stanford and published while at Stanford are included</li>
          <li>due to name ambiguities and the querying mechanism, there will be both false positive and false negative
              publication results in these aggregated counts</li>
          <li>topic areas are determined at the level of a journal (so all publications in a given journal will have the same topic area)</li>
        </ul>
      </p>
    </div>
  </section>
</template>


<script>
import ReportTable from 'rialto/reports/table'
import YearSlider from 'rialto/reports/yearSlider'

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
