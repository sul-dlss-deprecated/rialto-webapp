<template>
  <section class="container">
    <h1>Welcome to Rialto.</h1>

    <div class="row">
      <div class="col-sm-3">
        <div class="card">
          <img class="card-img-top" src="https://loremflickr.com/320/240" alt="Lorem ipsum">
          <div class="card-body">
            <h5 class="card-title">Explore Data</h5>
            <p class="card-text">Explore the data using search and facet filters</p>
            <router-link :to="{ name: 'search'}" class="btn btn-primary">Exploring</router-link>
          </div>
        </div>
      </div>

      <div class="col-sm-3">
        <div class="card">
          <img class="card-img-top" src="https://loremflickr.com/320/240/cat" alt="Lorem ipsum">
          <div class="card-body">
            <h5 class="card-title">Visualizations</h5>
            <p class="card-text">See how Stanford researchers connect with the world</p>
            <router-link :to="{ name: 'visualizations'}" class="btn btn-primary">Visualize</router-link>
          </div>
        </div>
      </div>

      <div class="col-sm-3">
        <div class="card">
          <img class="card-img-top" src="https://loremflickr.com/320/240/kitty" alt="Lorem ipsum">
          <div class="card-body">
            <h5 class="card-title">Reports</h5>
            <p class="card-text">Download spreadsheets of the data.</p>
            <router-link :to="{ name: 'reports'}" class="btn btn-primary">Download</router-link>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>


<script>

export default {
}
</script>

<style scoped>
</style>
