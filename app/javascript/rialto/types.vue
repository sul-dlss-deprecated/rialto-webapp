<template>
  <table class="types">
    <tr v-for="type in types">
      <td class="type" v-html="pluralize(type.value) + ':'"></td>
      <td class="count" v-html="type.hits.toLocaleString()"></td>
    </tr>
  </table>
</template>

<script>
export default {
  name: 'Types',
  data: function () {
    return {
      types: ''
    }
  },
  methods: {
    retrieveResults: function(url) {
      this.$http.get(url).then(function(response){
        this.types = response.body.response.facets.items
      }, function(error){
          console.error(error.statusText);
      });
    },
    pluralize: function(text) {
      switch(text) {
        case 'Person':
          return 'People'
        default:
          return `${text}s`
      }
    }
  },
  created() {
    this.retrieveResults('/catalog/facet/type_ssi.json')
  }
}
</script>

<style scoped>
.types {
  margin-top: .2rem;
}
.type, .count {
  padding:0;
}
.type {
  padding-right: .5rem;
}
.count {
  text-align: right;
}
</style>
