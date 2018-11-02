<template>
  <section class="container">
    <h1 class="mt-5 mb-5">Discover patterns of research, publication, and funding</h1>

    <div class="row">
      <div class="col-sm-4">
        <div class="card intl-collab">
          <img class="card-img-top" src="/home_intlcollab.png" alt="Topic Area">
          <div class="card-img-overlay">
            <div class="fas fa-globe-americas icon"></div>
            <h2 class="card-title">Discover<br>international<br>collaborations</h2>
          </div>
          <div class="card-body">
            <!-- <p class="card-text">any text here</p> -->
            <!--<router-link :to="{ name: 'visualizations'}" class="btn btn-primary">Search</router-link>-->
          </div>
        </div>
      </div>

      <div class="col-sm-4">
        <div class="card">
          <img class="card-img-top" src="/home_topicarea.png" alt="Topic Area">
          <div class="card-img-overlay">
            <div class="fas fa-landmark icon"></div>
            <h2 class="card-title">Collaboration<br>by co-author, institution, and country</h2>
          </div>
          <div class="card-body">
            <!-- <p class="card-text">any text here</p> -->
            <router-link :to="{ name: 'collaboration_report'}" class="btn btn-primary">Search</router-link>
          </div>
        </div>
      </div>

      <div class="col-sm-4">
        <div class="card">
          <img class="card-img-top" src="/home_trends.png" alt="Research trends by topic">
          <div class="card-img-overlay">
            <div class="fas fa-book icon"></div>
            <h2 class="card-title">Cross-disciplinary research<br>by concept</h2>
          </div>
          <div class="card-body">
              <router-link :to="{ name: 'crossDisplinaryReport'}" class="btn btn-primary">Search</router-link>
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

<style lang="scss" scoped>
  @import '../../variables';

  h1 {
    color: $header-text-color;
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 230%;
    text-align: center;
  }
  .icon {
    margin-top: 1rem;
    font-size: 500%;
  }
  h2 {
    font-family: 'Source Sans Pro', sans-serif;
    font-weight: bold;
    margin-top: 2rem;
  }
  .card-img-top {
    background-color: white;
    height: 274px;
    // width: 200px;
    // margin: -75px 0 0 -100px;
  }
  .card-body {
    z-index: 1000; // push the .card-body over the .card-img-overlay
  }
  .card {
    background-color: $card-background;
    text-align: center;
    overflow: hidden;
  }

</style>
