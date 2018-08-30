<template>
  <section class="container">
    <h1>Visualizations</h1>
    <select name="department" v-model="selectedDepartment">
      <option value="">Select a department</option>
      <option v-for="department in departments" :value="department">{{ department.label }}</option>
    </select>
    <Choropleth v-bind:department="selectedDepartment"/>
  </section>
</template>


<script>
import Choropleth from '../choropleth.vue'
export default {
  components: {
    Choropleth
  },
  data: function () {
    return {
      selectedDepartment: '',
      departments: [],
    }
  },
  created() {
    var result = this.$http.get('/departments').then(function(response){
        this.departments = response.data
    }, function(error){
        console.error(error.statusText);
    })
  },
  methods: {
    data_source: function() {
      `/reports/coauthors.csv?department_id=${this.selectedDepartment.id}`
    }
  }
}
</script>

<style scoped>
</style>
