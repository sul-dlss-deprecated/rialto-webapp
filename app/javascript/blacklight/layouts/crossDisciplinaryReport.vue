<template>
  <section class="container">
    <h1>Cross-Disciplinary Research Report</h1>
    <label for="concept">Concept: </label>
    <select name="concept" v-model="selectedConcept">
      <option v-for="concept in concepts" :value="concept">{{ concept.label }}</option>
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
