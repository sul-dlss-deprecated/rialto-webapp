<template>
  <div v-if="reportURL" class="form-group small">
    <label for="reportURL">Data URL:</label>
    <input id="reportURL" readonly class="form-control small" v-model="reportURL">
  </div>
</template>

<script>

export default {
  props: ['value'],
  computed: {
    reportURL: function(){
      if (!this.value) {
          return null
      }
      return `${location.href.replace(location.pathname + location.hash,"")}${this.value}`
    }
  }
}
</script>

<style lang="scss" scoped>
.form-control.small {
  font-size: 80%;
}
</style>
