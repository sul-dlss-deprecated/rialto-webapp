<template>
  <li>
    <template v-if="removeUrl() !== undefined">
      {{value.attributes.label}}
      <a href="#" v-on:click="remove"><span class="remove-icon">X</span></a>
    </template>
    <template v-else>
      <a href="#" v-on:click="setURL" v-html="value.attributes.label"></a>
    </template>
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
    },
    removeUrl: function() {
      return this.value.links.remove
    },
    remove: function() {
      this.$parent.$parent.$parent.$emit('facet', this.removeUrl())
    }
  }
}
</script>

<style scoped>
</style>
