<template>
  <section class="col-md-3">
    <div>
      <FacetItem v-for="facet in facets" v-bind:item="facet" />
    </div>
  </section>
</template>

<script>

import FacetItem from 'blacklight/facetItem.vue'

export default {
  components: {
    FacetItem
  },
  props: ['facets']
}
</script>

<style scoped>
</style>
