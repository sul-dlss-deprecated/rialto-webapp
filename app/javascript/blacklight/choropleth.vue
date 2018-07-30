<template>
  <div id='choropleth'>
  </div>
</template>

<script>
import * as Plotly from 'plotly.js';

export default {
  name: 'Choropleth',
  mounted(){
    Plotly.d3.csv('/data.csv', function(err, rows){
          function unpack(rows, key) {
              return rows.map(function(row) { return row[key]; });
          }

           var data = [{
                type: 'choropleth',
                locations: unpack(rows, 'CODE'),
                z: unpack(rows, 'GDP (BILLIONS)'),
                text: unpack(rows, 'COUNTRY'),
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
              geo:{
                  showframe: false,
                  showcoastlines: false,
                  projection:{
                      type: 'mercator'
                  }
              }
          };
          Plotly.plot('choropleth', data, layout, {showLink: false, displayModeBar: false});
    });

  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
