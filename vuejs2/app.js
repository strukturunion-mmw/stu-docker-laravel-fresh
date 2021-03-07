
// Initial VueJS Configuration with sample component
import Vue from "vue";

import Vuex from "vuex";
Vue.use(Vuex);

import VueRouter from "vue-router";
Vue.use(VueRouter);

const router = new VueRouter( {
    mode: 'history',
    routes: require('./vuejs/routes.js')
})

const store = new Vuex.Store({
    state: {

    },
    mutations: {

    },
    actions: {

    }
});

const app = new Vue({
    router,
    store,
    el: "#app",
})