<template>
  <div>
    <h3><router-link :to="{ name: 'show', params: { id: this.item.id } }" v-html="title"></router-link></h3>
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
      if (this.item.attributes === undefined)
        return this.item.id
      if (this.item.type === 'http://xmlns.com/foaf/0.1/Organization' ||
          this.item.type === 'http://xmlns.com/foaf/0.1/Person')
        return this.item.attributes['name_ssim'].attributes.value

      return this.item.attributes['title_tesi'].attributes.value
    }
  }
}
</script>

<style scoped>
</style>
