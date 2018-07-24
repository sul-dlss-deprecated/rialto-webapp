<template>
  <ul>
    <li v-for="result in results">
      <ResultItem v-bind:item="result" />
    </li>
  </ul>
</template>

<script>

import ResultItem from 'blacklight/resultItem.vue'

export default {
  components: {
    ResultItem
  },
  props: ['results']
}
</script>

<style scoped>
</style>
