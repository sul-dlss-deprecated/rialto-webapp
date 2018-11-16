<template>
  <section class="container">
    <h1>Research Trends Report</h1>

    <div class="form-group">
      <div class="row">
        <input type="radio" name="part" id="part" value="part" class="form-check-input" v-model="picked" />
        <label for="school" class="col-form-label col-sm-2">School: </label>
        <select name="school" class="col-sm-10" v-model="selectedSchool" @change="loadDepartments">
          <option v-for="school in schools" :value="school">{{ school.label }}</option>
        </select>
        <label for="department"  class="col-form-label col-sm-2">Department: </label>
        <select name="department" class="col-sm-10" v-model="selectedDepartment">
          <option v-for="department in departments" :value="department">{{ department.label }}</option>
        </select>
      </div>
      <div class="row">
        <input type="radio" name="all" id="all" value="all" class="form-check-input" v-model="picked" />
        <label class="form-check-label col-sm-2" for="all">All Stanford</label>
      </div>
    </div>
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
    <SourceInfo v-model="reportURL"></SourceInfo>
  </section>
</template>


<script>
import ReportTable from 'rialto/reports/table'
import YearSlider from 'rialto/reports/yearSlider'
import SourceInfo from 'rialto/reports/sourceInfo'

export default {
  components: {
    ReportTable,
    YearSlider,
    SourceInfo
  },
  data: function () {
    return {
      selectedSchool: '',
      schools: [],
      selectedDepartment: '',
      departments: [],
      selectedYearsRange: [2000, (new Date()).getFullYear()],
      picked: 'part'
    }
  },
  created() {
    var result = this.$http.get('/schools').then(function(response){
        this.schools = response.data
    }, function(error){
        console.error(error.statusText);
    });
    this.loadDepartments();
  },
  computed: {
    reportURL: function(){
        let org_qs = '';
        if (this.picked == 'part') {
            if (!(this.selectedSchool || this.selectedDepartment)) {
                return null
            }
            org_qs = '&org_uri=' + (this.selectedDepartment || this.selectedSchool).uri
        }
        return `/reports/research-trends.csv?start_year=${this.selectedYearsRange[0]}&end_year=${this.selectedYearsRange[1]}${org_qs}`
    }
  },
  methods: {
    download: function() {
      window.location = this.reportURL
    },
    loadDepartmentsUrl: function() {
        let url = '/departments'
        if (this.selectedSchool != '') {
            url += '?parent_school=' + this.selectedSchool.uri
        }
        return url;
    },
    loadDepartments: function() {
        this.selectedDepartment = '';
        var result = this.$http.get(this.loadDepartmentsUrl()).then(function(response){
            this.departments = response.data;
        }, function(error){
            console.error(error.statusText);
        })
    }

  }
}
</script>

<style scoped>
</style>
