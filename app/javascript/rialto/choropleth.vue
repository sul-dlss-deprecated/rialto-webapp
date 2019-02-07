<template>
  <div id='choropleth'>
  </div>
</template>

<script>
import * as Plotly from 'plotly.js';

export default {
  name: 'Choropleth',
  props: ['parsedCSV'],
  watch: {
      parsedCSV: function(newParsedCSV, oldParsedCSV) {
        if (newParsedCSV) {
          this.draw()
      }
    }
  },
  created: function () {
      // This is necessary to force drawing when toggling visibility with v:if
      if (this.parsedCSV) {
          this.draw()
      }
  },
  methods: {
    draw: function () {
        function unpack(rows, key) {
          return rows.map(function(row) {
              if (row[0] != 'United States of America') {
                  return row[key];
              }
          });
      }

      // 0 is Co-Author Country
      // 1 is Number of Collaborations
      var data = [{
          type: 'choropleth',
          locationmode: 'country names', // default is ISO-3
          locations: unpack(this.parsedCSV, 0),
          z: unpack(this.parsedCSV, 1),
          text: unpack(this.parsedCSV, 0),
          colorscale: [
              [0,'rgb(5, 10, 172)'],[0.35,'rgb(40, 60, 190)'],
              [0.5,'rgb(70, 100, 245)'], [0.6,'rgb(90, 120, 245)'],
              [0.7,'rgb(106, 137, 247)'],[1,'rgb(220, 220, 220)']],
          autocolorscale: false,
          reversescale: true,
          marker: {
              line: {
                  color: 'rgb(180,180,180)',
                  width: 0.5
              }
          },
          tick0: 0,
          zmin: 0,
          dtick: 1000,
          colorbar: {
              autotic: false,
              tickprefix: '',
              title: 'Number of collaborations'
          }
      }];

      var layout = {
        title: 'Collaborations',
        height: 600,
        width: 1000,
        geo:{
            showframe: true,
            showcoastlines: true,
            projection:{
                type: 'robinson'
            }
        }
      };

      Plotly.newPlot('choropleth', data, layout, {showLink: false, displayModeBar: false});
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
