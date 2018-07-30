<template>
  <div id="foo">
    <d3-network :net-nodes="nodes" :net-links="links" :options="options" />
  </div>
</template>

<script>
import D3Network from 'vue-d3-network'

export default {
  name: 'NetworkVisualization',
  components: {
    D3Network
  },
  data: function() {
    return {
      options: {
        force: 3000,
        nodeSize: 20,
        nodeLabels: true,
        linkWidth:5
      },
      nodes: [
          { id: 1, name: 'Stanford' },
        { id: 2, name: 'Cornell' },
        { id: 3, name: 'Minnesota', _color:'orange' },
        { id: 4, name: 'Cal', _size: '50' },
        { id: 5, name: 'Northwestern' },
        { id: 6, name: 'Columbia' },
        { id: 7, name: 'York' },
        { id: 8, name: 'Penn State' },
        { id: 9, name: 'Harvard' }],
      links: [
        { sid: 1, tid: 2, _color:'red' },
        { sid: 2, tid: 8, _color:'lightgray' },
        { sid: 3, tid: 4, _color:'rebeccapurple' },
        { sid: 4, tid: 5, _color:'lightgray' },
        { sid: 5, tid: 6, _color:'lightgray' },
        { sid: 7, tid: 8, _color:'lightgray' },
        { sid: 5, tid: 8, _color:'lightgray' },
        { sid: 3, tid: 8, _color:'lightgray' },
        { sid: 7, tid: 9, _color:'lightgray' }
      ]
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
