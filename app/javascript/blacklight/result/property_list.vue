<template>
  <dl>
    <template v-for="(property, index) in filteredAttributes">
      <dt v-html="property.attributes.label"></dt>
      <dd v-html="property.attributes.value"></dd>
    </template>
  </dl>
</template>

<script>
export default {
  props: ['item'],
  computed: {
    filteredAttributes: function() {
        let newAttributes = {};
        for(let property in this.item.attributes) {
            if (property != 'title_tesi' && property != 'name_tsim') {
                newAttributes[property] = this.item.attributes[property]
            }
        }
        return newAttributes
    }
  },
}
</script>

<style scoped>
</style>
