<template>

  <div id="app">
    <nav class="navbar navbar-expand-md navbar-dark bg-dark topbar" role="navigation">
        <a href="/" class="navbar-brand">Rialto</a>
    </nav>
    <Search />
  </div>
</template>

<script>

import Search from 'blacklight/search.vue'

export default {
  components: {
    Search
  }
}
</script>

<style>

</style>
