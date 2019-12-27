<template>
  <iframe :src="url" />
</template>

<script>
  export default {
    props: ['url']
  }
</script>

<style scoped>
  iframe {
    height: 100%;
    width: 100%;
  }
</style>
