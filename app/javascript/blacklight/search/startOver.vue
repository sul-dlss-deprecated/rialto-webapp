<template>
  <div class="constraints-container" v-if="showButton" >
    <router-link :to="{ name: 'search'}" class="btn btn-primary">Start Over</router-link>
  </div>
</template>

<script>

export default {
  computed: {
    showButton() {
      return typeof(this.$route.params.filter) !== 'undefined'
    }
  }
}
</script>

<style scoped>
</style>
