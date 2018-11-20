<template>

  <div id="app">
    <vue-progress-bar></vue-progress-bar>
    <nav class="navbar navbar-expand-md" role="navigation">
      <a class="navbar-brand" href="/">Stanford Libraries</a>
    </nav>
    <header class="masthead row">
      <div class="col-sm-10">
        <h1 class="site-title">Rialto</h1>
      </div>
      <div class="col-sm-2 d-none d-sm-block">
        <img src="beta.png">
      </div>
    </header>
    <nav class="navbar navbar-expand-md navbar-dark subnav" role="navigation">
      <ul class="navbar-nav mr-auto">
        <li class="nav-item"><router-link :to="{ name: 'home'}" class="nav-link">Analytics</router-link></li>
        <li class="nav-item"><router-link :to="{ name: 'search'}" class="nav-link">Browse</router-link></li>
        <li class="nav-item"><router-link :to="{ name: 'about'}" class="nav-link">About</router-link></li>
      </ul>
    </nav>
    <router-view></router-view>
  </div>
</template>

<script>
</script>

<style lang="scss">
  @import './app.scss';

  // Our own local variables
  $masthead-background: $cardinal;
  $masthead-color: $white;

  .navbar {
    padding-top: 0.1rem;
    padding-bottom: 0.3rem;
    line-height: 1;
    padding-left: 7px;
  }
  .navbar-brand {
    background: transparent url(/StanfordLibraries-logo-cmyk.png) no-repeat bottom left;
    overflow: hidden; // don't show the text in the link tag
    text-indent: 100%; // Push the real text off the display, but leave it available for screen readers
    min-width: 180px; // Allows the whole logo to display regardless of the text in the link tag
  }
  .masthead {
    font-family: 'Source Serif Pro', serif;
    height: 100px;
    text-transform: uppercase;
    background-color: $masthead-background;
    color: $masthead-color;
    .site-title {
      font-size: 300%;
      padding-top: 1.5rem;
      padding-left: 1.5rem;
      font-weight: 200;
    }
  }

  .subnav {
    background-color: $subnav-background;
    .navbar-nav {
      margin-left: 0.5rem;
      .nav-link {
        font-weight: bold;
      }
    }
  }
</style>
