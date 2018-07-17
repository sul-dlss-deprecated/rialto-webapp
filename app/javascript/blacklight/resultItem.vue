<template>
  <div>
    <h3><a v-bind:href="url" v-html="item.attributes['title_tsim']"></a></h3>
    <dl>
      <template v-for="(attribute, index) in item.attributes">
        <dt>{{index}}</dt><dd v-html="attribute"></dd>
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
      return this.item.id
    }
  }
}
</script>

<style scoped>
</style>
