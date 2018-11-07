<template>
  <div class="navbar-search navbar navbar-light bg-faded" role="navigation">
    <form @submit.prevent="search" class="container">
      <label for="q" class="sr-only">search for</label>
      <div class="input-group">
        <input v-model="q" name="q" class="form-control" placeholder="Search..." autofocus="autofocus">
        <span class="input-group-append">
          <button type="submit" class="btn btn-primary search-btn" id="search">
            <span class="submit-search-text">Search</span>
            <span class="blacklight-icons"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16"><title>Search</title><g fill="none"><g stroke="#000"><circle cx="6" cy="6" r="5"/><path d="M14 14L10 10" style="stroke-linejoin:round;stroke-width:2"/></g></g></svg>
            </span>
          </button>
        </span>
      </div>
    </form>
  </div>
</template>

<script>

export default {
  data: function() {
    return {
      q: ''
    }
  },
  methods: {
    search: function(event) {
      this.$parent.$emit('send', this.q)
    }
  }
}
</script>

<style scoped>
</style>
