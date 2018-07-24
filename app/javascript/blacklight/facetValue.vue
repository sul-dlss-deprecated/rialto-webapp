<template>
  <li>
    <a href="#" v-on:click="setURL">{{value.attributes.label}}</a>
    {{value.attributes.hits}}
  </li>
</template>

<script>
export default {
  props: ['value'],
  methods: {
    setURL: function() {
      this.$parent.$parent.$parent.$emit('facet', this.url())
    },
    url: function() {
      return this.value.links.self
    }
  }
}
</script>

<style scoped>
</style>
