<template>
  <section class="container">
    <h1>Collaboration Report</h1>
    <div class="form-group">
      <div class="row">
        <!--<input type="radio" name="part" id="part" value="part" class="form-check-input" v-model="picked" />-->
        <label for="school" class="col-form-label col-sm-2">School: </label>
        <select name="school" class="col-sm-10" v-model="selectedSchool" @change="loadDepartments">
          <option v-for="school in schools" :value="school">{{ school.label }}</option>
        </select>
        <label for="department"  class="col-form-label col-sm-2">Department: </label>
        <select name="department" class="col-sm-10" v-model="selectedDepartment">
          <option v-for="department in departments" :value="department">{{ department.label }}</option>
        </select>
      </div>
      <!--<div class="row">-->
        <!--<input type="radio" name="all" id="all" value="all" class="form-check-input" v-model="picked" />-->
        <!--<label class="form-check-label col-sm-2" for="all">All Stanford</label>-->
      <!--</div>-->
    </div>
    <YearSlider v-model="selectedYearsRange" v-bind:maxRange="5"></YearSlider>
    <div class="form-group row">
      <label for="reportType" class="col-sm-2 col-form-label">Report type: </label>
      <select name="reportType" v-model="selectedReportType">
          <option value="coauthors">Co-authors</option>
          <option value="coauthor-institutions">Co-author institutions</option>
          <option value="coauthor-countries">Co-author countries</option>
      </select>
    </div>
    <div v-if="selectedReportType == 'coauthor-institutions'" class="alert alert-light">
        <p>This report aggregates and counts the number of co-authors at each institution for papers authored by Stanford
            researchers. You can filter by school, department and date of publication. Note that it includes Stanford
            co-authors, so Stanford University will often be the top result, which indicates Stanford authors often
            collaborate with other Stanford authors. You may also download the results as a CSV file.</p>
    </div>
    <div v-if="selectedReportType == 'coauthor-countries'" class="alert alert-light">
        <p>This report aggregates and counts the number of co-authors in each country for papers authored by Stanford
            researchers. You can filter by school, department and date of publication. Note that it includes Stanford
            co-authors, so the count of the USA will include many instances of inter-Stanford collaborations. You may
            also download the results as a CSV file.</p>
    </div>
    <div v-if="selectedReportType == 'coauthors'" class="alert alert-light">
        <p>This report includes data that can be used to perform further analysis of co-authors collaborations. The
            output is one row per unique author/co-author pair per publication and may include multiple rows per paper,
            if the paper has multiple co-authors. The number of collaborations column counts the number of times that
            author/co-author pair have collaborated (i.e. the number of publications that include that particular
            collaboration between two authors). This means that any number bigger than 1 in this column indicates that
            more than one paper is represented by that row. Also note that authors can have multiple institutional
            affiliations, either through previous or current co-affiliations, as determined by the publications being
            aggregated over. This would be shown as multiple countries and institutions for that collaboration in that
            row. You can filter by school, department and date of publication.</p>

        <p>By design, this report will include a lot of data if you select a broad filtering, and only a limited result
            set is shown on screen. You may download the full result set as a CSV, but it may take some time to generate
            and may be a very large file to download.</p>
    </div>
    <ul v-if="reportURL">
      <li><a href="#" v-on:click="download">Download</a></li>
    </ul>
    <ReportTable v-bind:data-source="reportURL" v-bind:paginated="isPaginated"></ReportTable><br />
    <div v-if="selectedReportType === 'coauthor-countries'">
      <Choropleth v-bind:reportURL="reportURL"/>
    </div>

    <div class="alert alert-light">
      <p>Co-author data for these reports are pulled from publications in the Web of Science, a Clarivate product.
         Publications are determined by querying the web of science by Stanford researcher name, and are updated
         monthly. Note that some limits of this report include:
        <ul>
          <li>not all publications are represented in the Web of Science, and coverage by subject area will vary</li>
          <li>only publications from authors currently at Stanford and published while at Stanford are included</li>
          <li>due to name ambiguities and the querying mechanism, there will be both false positive and false
              negative publication results in these aggregated counts</li>
        </ul>
      </p>
    </div>
    <SourceInfo v-model="reportURL"></SourceInfo>
  </section>
</template>


<script>
import ReportTable from 'rialto/reports/table'
import Choropleth from 'rialto/choropleth'
import YearSlider from 'rialto/reports/yearSlider'
import SourceInfo from 'rialto/reports/sourceInfo'

export default {
  components: {
    YearSlider,
    ReportTable,
    Choropleth,
    SourceInfo
  },
  data: function () {
    return {
      selectedSchool: '',
      schools: [],
      selectedDepartment: '',
      departments: [],
      selectedReportType: 'coauthor-countries',
      selectedYearsRange: [(new Date()).getFullYear()-5, (new Date()).getFullYear()],
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
      return `/reports/${this.selectedReportType}.csv?start_year=${this.selectedYearsRange[0]}&end_year=${this.selectedYearsRange[1]}${org_qs}`
    },
    isPaginated: function(){
        if (this.selectedReportType == 'coauthors') {
            return true;
        }
        return false;
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
