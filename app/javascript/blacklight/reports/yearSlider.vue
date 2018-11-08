<template>
  <div class="form-group">
    <label for="yearsRange">Years: </label>
    <vue-slider name="yearsRange" v-model="mutableRange" @input="onInput" :min=min :max=max width="80%"></vue-slider>
  </div>
</template>

<script>
import vueSlider from 'vue-slider-component';

export default {
  components: {
    vueSlider
  },
  props: {
    'value': Array,
    max: {
      type: Number,
      default: (new Date()).getFullYear()
    },
    min: {
      type: Number,
      default: 2000
    }
  },
  data: function () {
    return {
      mutableRange: this.value,
    }
  },
  methods: {
    onInput: function(val) {
      this.$emit('input', val);
    }
  }
}
</script>

<style scoped>
.form-group {
  margin-bottom: 1rem;
}
</style>
