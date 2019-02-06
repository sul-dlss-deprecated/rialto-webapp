<template>
  <section class="container">
    <h1>Cross-Disciplinary Research Report</h1>
    <div class="form-group">
      <div class="row">
          <input type="radio" name="part" id="part" value="part" class="form-check-input" v-model="picked" />
          <label for="concept" class="col-form-label col-sm-2">Research Area: </label>
          <select name="concept" class="col-sm-10" v-model="selectedConcept">
              <option v-for="concept in concepts" :value="concept">{{ concept.label }}</option>
          </select>
      </div>
      <div class="row">
          <input type="radio" name="all" id="all" value="all" class="form-check-input" v-model="picked" />
          <label class="form-check-label col-sm-2" for="all">All research areas</label>
      </div>
    </div>
    <div class="alert alert-light">
        <p>This report aggregates publications for a given research area and then breaks them down by researchers
            affiliated with Stanford cross-disciplinary institutes by year, in order to show trends for a given research
            area by institute and year. You need to select a research area to see results. Note that many areas will have
            no results associated with a Stanford institute.
        </p>
    </div>
    <ul v-if="reportURL">
      <li><a href="#" v-on:click="download">Download</a></li>
    </ul>
    <ReportTable v-bind:data-source="reportURL"></ReportTable>
    <div class="alert alert-light">
      <p>Research area data for these reports are pulled from publications in the Web of Science, a Clarivate product.
         Note that Clarivate categorizes publications into research areas at the level of a journal (not individual
         publications). Note that some limits of this report include:
        <ul>
          <li>not all publications are represented in the Web of Science, and coverage by subject area will vary</li>
          <li>only publications from authors currently at Stanford and published while at Stanford are included</li>
          <li>only publications for Stanford authors that also have an Stanford institute affiliation are included</li>
          <li>due to name ambiguities and the querying mechanism, there will be both false positive and false negative
              publication results in these aggregated counts</li>
          <li>research areas are determined at the level of a journal (so all publications in a given journal will have
              the same research areas</li>
        </ul>
      </p>
    </div>
    <SourceInfo v-model="reportURL"></SourceInfo>
  </section>
</template>


<script>
import ReportTable from 'rialto/reports/table'
import SourceInfo from 'rialto/reports/sourceInfo'
import HttpError from 'rialto/mixins/httpError'

export default {
  mixins: [HttpError],
  components: {
    ReportTable,
    SourceInfo
  },
  data: function () {
    return {
      selectedConcept: '',
      concepts: [],
      picked: 'part'
    }
  },
  created() {
    var result = this.$http.get('/concepts').then(function(response){
        this.concepts = response.data
    }, function(error){
        this.handleHttpError(error);
    })
  },
  computed: {
    reportURL: function(){
        let concept_qs = '';
        if (this.picked === 'part') {
            if (!this.selectedConcept) {
                return null
            }
            concept_qs = `?concept_uri=${this.selectedConcept.uri}`
        }
        return `/reports/cross-disciplinary.csv${concept_qs}`
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
