<template>
  <section class="container">
    <h1 v-html="result.data.attributes['title_tsim']"></h1>
    <dl>
    <template v-for="(attribute, index) in result.data.attributes">
      <dt>{{index}}</dt><dd v-html="attribute"></dd>
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
    const endpoint = `/catalog/${this.$route.params.id}`
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
