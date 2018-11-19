<template>
  <section class="container">
    <h1>Cross-Disciplinary Research Report</h1>
    <label for="concept">Topic area: </label>
    <select name="concept" v-model="selectedConcept">
      <option v-for="concept in concepts" :value="concept">{{ concept.label }}</option>
    </select>
    <div class="alert alert-light">
      <p>This report aggregates publications for a given topic area and then breaks them down by researchers
         affiliated with Stanford cross-disciplinary institutes by year, in order to show trends for a given topic
         area by institute and year. You need to select a topic area to see results.
      </p>
    </div>
    <ul v-if="reportURL">
      <li><a href="#" v-on:click="download">Download</a></li>
    </ul>

    <ReportTable v-bind:data-source="reportURL"></ReportTable>
    <div class="alert alert-light">
      <p>Topic area data for these reports are pulled from publications in the Web of Science, a Clarivate product.
         Note that Clarivate categorizes publications into topic area at the level of a journal (not individual
         publications). Note that some limits of this report include:
        <ul>
          <li>not all publications are represented in the Web of Science, and coverage by subject area will vary</li>
          <li>only publications from authors currently at Stanford and published while at Stanford are included</li>
          <li>only publications for Stanford authors that also have an Stanford institute affiliation are included</li>
          <li>due to name ambiguities and the querying mechanism, there will be both false positive and false negative
              publication results in these aggregated counts</li>
          <li>topic areas are determined at the level of a journal (so all publications in a given journal will have
              the same topic area</li>
        </ul>
      </p>
    </div>
    <SourceInfo v-model="reportURL"></SourceInfo>
  </section>
</template>


<script>
import ReportTable from 'rialto/reports/table'
import SourceInfo from 'rialto/reports/sourceInfo'

export default {
  components: {
    ReportTable,
    SourceInfo
  },
  data: function () {
    return {
      selectedConcept: '',
      concepts: [],
    }
  },
  created() {
    var result = this.$http.get('/concepts').then(function(response){
        this.concepts = response.data
    }, function(error){
        console.error(error.statusText);
    })
  },
  computed: {
    reportURL: function(){
      if (!this.selectedConcept) {
        return null
      }
      return `/reports/cross-disciplinary.csv?concept_uri=${this.selectedConcept.uri}`
    }
  },
  methods: {
    download: function() {
      window.location = this.reportURL()
    }
  }
}
</script>

<style scoped>
</style>
