<template>
  <div class="card">
    <h3 class="card-header collapse-toggle"
        v-bind:class="{ collapsed: !isActive }"
        v-on:click.stop="toggle"><a v-bind:href="'#' + item.id">{{item.id}}</a></h3>
    <div class="card-body" v-bind:class="{ collapse: !isActive }">
      <ul class="list-unstyled">
        <li v-for="item in item.attributes.items">
          {{item.attributes.label}} {{item.attributes.hits}}
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  props: ['item'],
  data: function() {
    return {
      isActive: false
    }
  },
  methods: {
    toggle: function(e) {
      this.isActive = !this.isActive
    }
  }
}
</script>

<style scoped>
  .collapse-toggle:after {
    content: "❯";
    float: right;
    transform: rotate(90deg);
  }
  .collapse-toggle.collapsed:after {
    transform: rotate(0deg);
    transition: transform 0.1s ease;
  }
  .card-header {
    font-size: 1rem;
  }
  .card {
    margin-bottom: 1rem;
  }
</style>
