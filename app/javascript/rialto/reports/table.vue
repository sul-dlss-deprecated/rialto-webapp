<template>
  <section class="container">
    <div v-if="parsedCSV && parsedCSV.length > 1">
      <table class="table table-striped">
        <tr v-for="(row, index) in parsedCSV">
          <template v-if="index === 0">
            <th v-for="cell in row">
              {{ cell }}
            </th>
          </template>
          <template v-else>
            <td v-for="cell in row">
              {{ cell }}
            </td>
          </template>
        </tr>
      </table>
      <div v-if="paginated">
        <Pagination v-bind:rowsPerPage="rowsPerPage" v-bind:count="count" v-on:change-page="change_page"  />
      </div>
    </div>
    <div v-else-if="parsedCSV && parsedCSV.length <= 1">There is no data available with the selections above.</div>
  </section>
</template>

<script>
import d3 from 'd3'
import Pagination from 'rialto/reports/pagination'

export default {
  components: {
      Pagination,
  },
  props: ['dataSource','paginated'],
  data: function () {
    return {
      parsedCSV: null,
      count: null,
      rowsPerPage: 100,
    }
  },
  watch: {
    dataSource(newVal, oldVal) {
      this.$Progress.start()
      if (this.paginated) {
          d3.text(newVal + '&count=true', (data) => {
              this.count = d3.csv.parseRows(data)[1][0];
          });
          newVal += this.page_qs(0)
      }
      d3.text(newVal, (data) => {
        this.parsedCSV = d3.csv.parseRows(data);
        this.$Progress.finish()
      })
    }
  },
  methods: {
    page_qs: function(offset)  {
        return '&offset=' + offset + '&limit=' + this.rowsPerPage
    },
    change_page: function(offset) {
      this.$Progress.start()
      const url = this.dataSource + this.page_qs(offset);
      d3.text(url, (data) => {
          this.parsedCSV = d3.csv.parseRows(data);
          this.$Progress.finish()
      })
    }
  }
}
</script>

<style lang="scss" scoped>
  @import '../../variables';

  .table {
    background-color: white;
  }

  th {
    background-color: $card-background;
  }
</style>
