<template>
  <section class="container">
    <table v-if="parsedCSV" class="table table-striped">
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
  </section>
</template>

<script>
import d3 from 'd3'

export default {
  props: ['dataSource'],
  data: function () {
    return {
      parsedCSV: null
    }
  },
  watch: {
    dataSource(newVal, oldVal) {
      d3.text(newVal, (data) => {
        this.parsedCSV = d3.csv.parseRows(data);
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
