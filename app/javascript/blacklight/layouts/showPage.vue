<template>
  <section class="container">
    <h1><Title v-bind:item="item"></Title></h1>
    <PropertyList v-bind:item="item"></PropertyList>
  </section>
</template>


<script>
import Title from 'blacklight/result/title.vue'
import PropertyList from 'blacklight/result/property_list.vue'
import HttpError from 'blacklight/mixins/httpError'

export default {
  mixins: [HttpError],
  components: {
    Title,
    PropertyList
  },
  data() {
    return {
      item: { attributes: {} }
    }
  },
  methods: {
    load: function() {
      const endpoint = `/catalog/${encodeURIComponent(this.$route.params.id)}`
      this.$http.get(endpoint).then(function(response){
          this.item = response.data.data
      }, function(error){
          this.handleHttpError(error);
      })
    }
  },
  watch: {
    '$route': {
      handler: 'load',
      immediate: true
    }
  }
}
</script>

<style scoped>
</style>
