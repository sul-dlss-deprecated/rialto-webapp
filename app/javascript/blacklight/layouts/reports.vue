<template>
  <section class="container">
    <h1>Reports</h1>
    <label for="department">Department</label>
    <select name="department" v-model="selectedDepartment">
      <option v-for="department in departments" :value="department">{{ department.label }}</option>
    </select>

    <ul v-if="selectedDepartment !== ''">
      <li><a href="#" v-on:click="download">Collaboration Report</a></li>
    </ul>
  </section>
</template>


<script>
export default {
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
    download: function() {
      window.location = `/reports/${this.selectedDepartment.id}.csv`
    }
  }
}
</script>

<style scoped>
</style>
