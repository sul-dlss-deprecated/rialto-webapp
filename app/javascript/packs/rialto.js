/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue'
import App from '../app.vue'
import VueResource from  'vue-resource'
import VueRouter from  'vue-router'
import VueProgressBar from 'vue-progressbar'

Vue.use(VueResource)
Vue.use(VueRouter)
const options = {
  color: '#e62117',
  failedColor: '#874b4b',
  thickness: '5px',
  transition: {
    speed: '0.2s',
    opacity: '0.6s',
    termination: 300
  },
  autoRevert: true,
  inverse: false
}

Vue.use(VueProgressBar, options)

import Show from 'blacklight/layouts/showPage'
import Search from 'blacklight/layouts/search'
import Home from 'rialto/layouts/home'
import About from 'rialto/layouts/about'
import CollaborationReport from 'rialto/layouts/collaborationReport'
import CrossDisciplinaryReport from 'rialto/layouts/crossDisciplinaryReport'
import ResearchTrendsReport from 'rialto/layouts/researchTrendsReport'

const routes = [
  { path: '/item/:id', name: 'show', component: Show },
  { path: '/catalog/:filter?', name: 'search', component: Search },
  { path: '/reports', name: 'collaboration_report', component: CollaborationReport },
  { path: '/cross-disciplinary-report', name: 'crossDisplinaryReport', component: CrossDisciplinaryReport },
  { path: '/research-trends-report', name: 'research_trends_report', component: ResearchTrendsReport },
  { path: '/', name: 'home', component: Home },
  { path: '/about', name: 'about', component: About }

]

const router = new VueRouter({
  routes // short for `routes: routes`
})

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('hello'))
  const app = new Vue({
    router,
    el,
    render: h => h(App),
    http: {
      root: 'http://localhost:3000',
      headers: {
        Accept: 'application/json'
      }
    }
  })
})


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>


// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
//
//
//
// If the using turbolinks, install 'vue-turbolinks':
//
// yarn add 'vue-turbolinks'
//
// Then uncomment the code block below:
//
// import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// Vue.use(TurbolinksAdapter)
//
// document.addEventListener('turbolinks:load', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
