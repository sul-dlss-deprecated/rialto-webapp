<template>
  <div>
    <h3><a v-bind:href="url" v-html="title"></a></h3>
    <dl>
      <template v-for="(property, index) in item.attributes">
        <dt v-html="property.attributes.label"></dt>
        <dd v-html="property.attributes.value"></dd>
      </template>
    </dl>
  </div>
</template>

<script>
export default {
  props: ['item'],
  computed: {
    url: function () {
      return this.item.links.self
    },
    title: function () {
      return this.item.attributes['title_tsim'].attributes.value
    }
  }
}
</script>

<style scoped>
</style>
