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
          <FacetList v-bind:facets="result.facets" />
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
      endpoint: `/catalog?q=&page=${this.$route.query.page || 1}`
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
  computed: {
    links: function() {
      return this.result.links
    }
  },
  created() {
    // Triggered when "search" is pressed
    this.$on('send', (text) => {
      this.endpoint = '/catalog?q=' + text
      this.message = 'searching...';
      this.retrieveResults()
    })

    // Triggered when "next" or "previous" page is pressed
    this.$on('page', () => {
      if (this.links.self.match(/page=\d+/)) {
        this.endpoint = this.links.self.replace(/page=\d+/, `page=${this.$route.query.page}`)
      } else {
        this.endpoint = `${this.links.self}&page=${this.$route.query.page}`
      }
      this.retrieveResults()
    })

    // Triggered when a facet value is pressed
    this.$on('facet', (url) => {
      this.endpoint = url
      this.retrieveResults()
    })

    // Triggered when loaded
    this.retrieveResults()
  }
}
</script>

<style scoped>
</style>
