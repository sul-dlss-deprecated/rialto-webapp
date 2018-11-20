<template>
    <div>
      <nav>
        <ul class="pagination">
          <li class="page-item" v-bind:class="{ disabled: page == 1 }"><a class="page-link" v-on:click.stop="change_page(1)">First</a></li>
          <li class="page-item" v-bind:class="{ disabled: page == 1 }"><a class="page-link" v-on:click.stop="change_page(page-1)">Previous</a></li>
          <li class="page-item" v-bind:class="{ disabled: page == pages }"><a class="page-link" v-on:click.stop="change_page(page+1)">Next</a></li>
          <li class="page-item" v-bind:class="{ disabled: page == pages }"><a class="page-link" v-on:click.stop="change_page(pages)">Last</a></li>
        </ul>
      </nav>
      {{ count }} results. Page {{ page }} of {{ pages }} pages.
    </div>
</template>

<script>
import d3 from 'd3'

export default {
  props: ['count', 'rowsPerPage'],
  data: function () {
    return {
      page: 1
    }
  },
  computed: {
    pages: function() {
      return Math.ceil(this.count / this.rowsPerPage);
    }
  },
  methods: {
    offset: function() {
      return (this.page - 1) * this.rowsPerPage;
    },
    change_page: function(newPage) {
        this.page = newPage;
        this.$emit('change-page', this.offset())
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
