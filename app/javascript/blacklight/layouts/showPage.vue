<template>
  <section class="container">
    <h1><Title v-bind:item="item"></Title></h1>
    <PropertyList v-bind:item="item"></PropertyList>
  </section>
</template>


<script>
import Title from 'blacklight/result/title.vue'
import PropertyList from 'blacklight/result/property_list.vue'

export default {
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
      console.log("in load")

      const endpoint = `/catalog/${encodeURIComponent(this.$route.params.id)}`
      this.$http.get(endpoint).then(function(response){
          this.item = response.data.data
      }, function(error){
          console.error(error.statusText);
          alert("There was an error retrieveing this record")
      })
    }
  },
  watch: {
    '$route' (to, from) {
      // react to route changes...
      console.log("loading")
      this.load()
    }
  },
  created() {
    this.load()

  }
}
</script>

<style scoped>
</style>
