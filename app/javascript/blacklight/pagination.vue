<template>
  <div class="sort-pagination">
    <template v-if="pages.prev_page != null">
      <router-link :to="{ name: 'search', query: { page: pages.prev_page } }">Previous</router-link>
    </template>
    <template v-else>
      Previous
    </template>
    | {{start}} - {{end}} of {{totalCount}} |
    <template v-if="pages.next_page != null">
      <router-link :to="{ name: 'search', query: { page: pages.next_page } }">Next</router-link>
    </template>
    <template v-else>
      Next
    </template>
  </div>
</template>

<script>
export default {
  props: ['result'],
  computed: {
    pages: function() {
      return this.result.meta.pages
    },
    start: function () {
      return this.pages.offset_value + 1
    },
    end: function() {
      return Math.min(this.pages.offset_value + this.pages.limit_value, this.pages.total_count)
    },
    totalCount: function() {
      return this.pages.total_count
    }
  },
  watch: {
    '$route': function(to, from) {
      // react to route changes...
      this.$parent.$emit('page')
    }
  }
}
</script>

<style scoped>
.sort-pagination {
  border-bottom: 1px solid #dee2e6;
  margin-bottom: 1em;
  padding-bottom: 1em;
}
</style>
