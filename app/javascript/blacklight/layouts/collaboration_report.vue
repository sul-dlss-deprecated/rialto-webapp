<template>
  <section class="container">
    <h1>Collaboration Report</h1>
    <label for="department">Department: </label>
    <select name="department" v-model="selectedDepartment">
      <option v-for="department in departments" :value="department">{{ department.label }}</option>
    </select>
    <label for="reportType">Report type: </label>
    <select name="reportType" v-model="selectedReportType">
        <option value="coauthors">Co-authors</option>
        <option value="coauthor-institutions">Co-author institutions</option>
        <option value="coauthor-countries">Co-author countries</option>
    </select>
    <ul v-if="reportURL">
      <li><a href="#" v-on:click="download">Download</a></li>
    </ul>

    <ReportTable v-bind:data-source="reportURL"></ReportTable>
  </section>
</template>


<script>
import ReportTable from 'blacklight/reports/table.vue'

export default {
  components: {
    ReportTable
  },
  data: function () {
    return {
      selectedDepartment: '',
      departments: [],
      selectedReportType: 'coauthors'
    }
  },
  created() {
    var result = this.$http.get('/departments').then(function(response){
        this.departments = response.data
    }, function(error){
        console.error(error.statusText);
    })
  },
  computed: {
    reportURL: function(){
      if (!this.selectedDepartment || !this.selectedReportType) {
        return null
      }
      return `/reports/${this.selectedReportType}.csv?department_uri=${this.selectedDepartment.uri}`
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
