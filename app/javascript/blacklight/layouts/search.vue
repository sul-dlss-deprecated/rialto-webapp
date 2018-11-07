<template>
  <div>
    <SearchControl />
    <div class="container">
      <p>{{ message }}</p>
      <StartOver/>
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

import StartOver from 'blacklight/search/startOver.vue'
import SearchControl from 'blacklight/search/searchControl.vue'
import Result from 'blacklight/search/result'
import ResultList from 'blacklight/result/list.vue'
import FacetList from 'blacklight/facet/list.vue'
import Pagination from 'blacklight/search/pagination.vue'

export default {
  components: {
    SearchControl,
    StartOver,
    ResultList,
    FacetList,
    Pagination,
  },
  data: function () {
    return {
      message: "No results",
      result: new Result()
    }
  },
  methods: {
    // This is passed a solr query url and it transforms it to a frontend url
    solrUrlToPath: function(solrUrl) {
      return '/catalog/' + solrUrl.split('?', 2)[1]
    },
    retrieveResults: function(url) {
      this.$http.get(url).then(function(response){
          this.result = new Result(response.data)
          this.message = null
      }, function(error){
          console.error(error.statusText);
      });
    },
    load: function(route) {
      this.message = 'searching...';
      var filter = route.params.filter
      if (filter === undefined)
        filter = 'q='
      this.retrieveResults('/catalog?' + filter)
    }
  },
  computed: {
    links: function() {
      return this.result.links
    }
  },
  watch: {
    '$route': {
      handler: 'load',
      immediate: true
    }
  },
  created() {
    // Triggered when "search" is pressed
    this.$on('send', (text) => {
      this.$router.push(this.solrUrlToPath(`/catalog?q=${text}`))
    })

    // Triggered when "next" or "previous" page is pressed
    this.$on('page', (page) => {
      var state
      if (this.links.self.match(/page=\d+/)) {
        state = this.links.self.replace(/page=\d+/, `page=${page}`)
      } else {
        state = `${this.links.self}&page=${page}`
      }
      this.$router.push(this.solrUrlToPath(state))
    })

    // Triggered when a facet value is pressed
    this.$on('facet', (url) => {
      this.$router.push(this.solrUrlToPath(url))
    })
  }
}
</script>

<style scoped>
</style>
