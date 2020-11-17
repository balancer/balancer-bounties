import Vue from 'vue';
// import { camelCase, upperFirst } from 'lodash';
import App from './App.vue';

Vue.config.productionTip = false;

/*
const requireComponent = require.context('@/components', true, /[\w-]+\.vue$/);
// @ts-ignore
requireComponent.keys().forEach(fileName => {
  const componentConfig = requireComponent(fileName);
  const componentName = upperFirst(
    camelCase(fileName.replace(/^\.\//, '').replace(/\.\w+$/, ''))
  );
  Vue.component(componentName, componentConfig.default || componentConfig);
});
*/

new Vue({
  render: h => h(App)
}).$mount('#app');
