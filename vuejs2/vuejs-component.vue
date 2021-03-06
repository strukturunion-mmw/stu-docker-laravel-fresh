<template>
  <h2>
    {{message}}
  </h2>
</template>
<script>
const default_layout = "default";


export default {
  computed: {},
  data() {
    return {
      message:'Hello, I am a VueJS 2 component'
    }
  }
};
</script>