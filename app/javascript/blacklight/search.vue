<template>
  <div>
    <SearchControl />
    <p>{{ message }}</p>
    <ResultList v-bind:results="result.data" />
  </div>
</template>

<script>

import SearchControl from 'blacklight/searchControl.vue'
import Result from 'blacklight/result'
import ResultList from 'blacklight/resultList.vue'

export default {
  components: {
    SearchControl,
    ResultList
  },
  data: function () {
    return {
      message: "No results",
      result: new Result()
    }
  },
  methods: {
    retrieveResults: function(query) {
      const endpoint = '/catalog?q='
      this.$http.get(endpoint + query).then(function(response){
          this.result = new Result(response.data)
          this.message = null
      }, function(error){
          console.error(error.statusText);
      });
    }
  },
  created() {
    this.$on('send', (text) => {
      this.message = 'searching...';
      this.retrieveResults(text)
    })
  }
}
</script>

<style scoped>
</style>
