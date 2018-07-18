<template>
  <div>
    <SearchControl />
    <div class="container">
      <p>{{ message }}</p>
      <div class="row">
        <section class="col-md-9 order-last">
          <Pagination v-bind:result="result" />
          <ResultList v-bind:results="result.data" />
        </section>
        <section class="col-md-3">
          <FacetList v-bind:facets="result.included" />
        </section>
      </div>
    </div>
  </div>
</template>

<script>

import SearchControl from 'blacklight/searchControl.vue'
import Result from 'blacklight/result'
import ResultList from 'blacklight/resultList.vue'
import FacetList from 'blacklight/facetList.vue'
import Pagination from 'blacklight/pagination.vue'

export default {
  components: {
    SearchControl,
    ResultList,
    FacetList,
    Pagination,
  },
  data: function () {
    return {
      message: "No results",
      result: new Result(),
      endpoint: '/catalog?q='
    }
  },
  methods: {
    retrieveResults: function() {
      this.$http.get(this.endpoint).then(function(response){
          this.result = new Result(response.data)
          this.message = null
      }, function(error){
          console.error(error.statusText);
      });
    }
  },
  created() {
    this.$on('send', (text) => {
      this.endpoint = '/catalog?q=' + text
      this.message = 'searching...';
      this.retrieveResults()
    })
    this.$on('endpoint', (url) => {
      console.log("ENDPOINT")
      this.endpoint = url
      this.retrieveResults()
    })
    this.retrieveResults()
  }
}
</script>

<style scoped>
</style>
