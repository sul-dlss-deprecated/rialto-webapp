<template>
  <div class="form-group row">
    <label for="yearsRange" class="col-sm-2 col-form-label">Years: </label>
    <vue-slider name="yearsRange" v-model="mutableRange" @input="onInput" :min=min :max=max class="col-sm-10"></vue-slider>
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
