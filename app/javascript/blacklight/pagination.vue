<template>
  <div class="sort-pagination">
    <template v-if="links.prev != null">
      <a href="#next" v-on:click="previousPage" :disabled="!links.prev">Previous</a>
    </template>
    <template v-else>
      Previous
    </template>
    | {{start}} - {{end}} of {{totalCount}} |
    <template v-if="links.next != null">
      <a href="#next" v-on:click="nextPage" :disabled="!links.next">Next</a>
    </template>
    <template v-else>
      Next
    </template>
  </div>
</template>

<script>
export default {
  props: ['result'],
  methods: {
    nextPage: function() {
      history.pushState(history.state, "Rialto", this.links.next)
      this.$parent.$emit('endpoint', this.links.next)
    },
    previousPage: function() {
      history.pushState(history.state, "Rialto", this.links.prev)
      this.$parent.$emit('endpoint', this.links.prev)
    }
  },
  computed: {
    links: function() {
      return this.result.links
    },
    pages: function() {
      return this.result.meta.pages
    },
    start: function () {
      return this.pages.offset_value + 1
    },
    end: function() {
      return Math.min(this.start + this.pages.limit_value, this.pages.total_count)
    },
    totalCount: function() {
      return this.pages.total_count
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
