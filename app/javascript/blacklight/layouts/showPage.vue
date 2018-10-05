<template>
  <section class="container">
    <h1 v-html="result.data.attributes.title_tesi.attributes.value"></h1>
    <dl>
    <template v-for="(property, index) in result.data.attributes">
      <dt v-html="property.attributes.label"></dt>
      <dd v-html="property.attributes.value"></dd>
    </template>
    </dl>
  </section>
</template>


<script>

export default {
  components: {
  },
  data() {
    return {
      result: { data: { attributes: {} } }
    }
  },
  created() {
    const endpoint = `/catalog/${encodeURIComponent(this.$route.params.id)}`
    this.$http.get(endpoint).then(function(response){
        this.result = response.data
        this.message = null
    }, function(error){
        console.error(error.statusText);
    })
  }
}
</script>

<style scoped>
</style>
