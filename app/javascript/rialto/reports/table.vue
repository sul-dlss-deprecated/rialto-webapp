<template>
  <section class="container">
    <div v-if="parsedCSV && parsedCSV.length > 1">
      <table class="table table-striped">
        <tr v-for="(row, index) in parsedCSV">
          <template v-if="index === 0">
            <th v-for="cell in row">
              {{ cell }}
            </th>
            <th v-if="detailsFieldIndex !== null">
              Details
            </th>
          </template>
          <template v-else>
            <td v-for="cell in row">
              {{ cell }}
            </td>
            <td v-if="detailsFieldIndex !== null">
              <a href="#" v-on:click="download(row[detailsFieldIndex])">Download</a>
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
import axios from 'axios';

export default {
  components: {
      Pagination,
  },
  props: ['dataSource','paginated', 'detailsField'],
  data: function () {
    return {
      parsedCSV: null,
      count: null,
      rowsPerPage: 100,
      detailsFieldIndex: null,
    }
  },
  watch: {
    dataSource(newVal, oldVal) {
      if (!newVal) {
          this.count = null
          this.parsedCSV = null
          return
      }
      this.$root.$emit('progress-start')
      if (this.paginated) {
          axios.get(newVal + '&count=true', {responseType: 'text', timeout: 0})
              .then(response => {
                  this.count = d3.csv.parseRows(response.data)[1][0];
              }).catch(error => {
                  alert('The report could not be produced, perhaps due to the size of the data requested.  You can try again, reducing the scope of the data requested.');
              })
          newVal += this.page_qs(0)
      }
      axios.get(newVal, {responseType: 'text', timeout: 0})
          .then(response => {
              this.parsedCSV = d3.csv.parseRows(response.data)
              if (this.detailsFieldLabel) {
                  for (let i = 0; i < this.parsedCSV[0].length; i++) {
                      if (this.parsedCSV[0][i] == this.detailsFieldLabel) {
                          this.detailsFieldIndex = i;
                      }
                  }
              } else {
                  this.detailsFieldIndex = null;
              }
              this.$root.$emit('progress-stop');
          }).catch(error => {
              this.$root.$emit('progress-stop');
              alert('The report could not be produced, perhaps due to the size of the data requested.  You can try again, reducing the scope of the data requested.');
          });
    },
    parsedCSV(newVal, oldVal) {
        this.$emit('change-parsedCSV', newVal);
    }
  },
  computed: {
    detailsFieldLabel: function() {
        if (this.detailsField) {
            return this.detailsField[0];
        }
        return null;
    },
    detailsFieldParam: function() {
        if (this.detailsField) {
            return this.detailsField[1];
        }
        return null;
    }
  },
  methods: {
    page_qs: function(offset)  {
        return '&offset=' + offset + '&limit=' + this.rowsPerPage
    },
    change_page: function(offset) {
      this.$root.$emit('progress-start')
      const url = this.dataSource + this.page_qs(offset);
      axios.get(url, {responseType: 'text', timeout: 0})
          .then(response => {
              this.parsedCSV = d3.csv.parseRows(response.data)
              this.$root.$emit('progress-stop')
          }).catch(error => {
              this.$root.$emit('progress-stop');
              alert('The report could not be produced, perhaps due to the size of the data requested.  You can try again, reducing the scope of the data requested.');
          });
    },
    download: function(value) {
        const url = this.dataSource + '&details=true&' + this.detailsFieldParam + '=' + value;
        window.location = url
    },
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
