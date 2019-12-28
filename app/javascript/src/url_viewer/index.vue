<template>
  <div class="w-full h-full relative">
    <div v-if="!loaded" class="fully-centered">
      <i class="fas fa-spinner fa-pulse fa-3x"></i>
      <span class="text">Loading page...</span>
    </div>

    <iframe :src="url" v-on:load="urlLoaded" class="hidden" />

    <div v-if="loaded && loadingError" class="fully-centered">
      <span class="text">Failed to load URL.</span>
    </div>
  </div>
</template>

<script>
  export default {
    props: ['url'],
    data: () => ({
      loaded:       false,
      loadingError: false,
    }),
    methods: {
      urlLoaded: function(e) {
        const iframe = e.target
        this.loaded  = true

        try {
          const loadedSuccessfully = iframe.contentWindow.window.length != 0

          if (loadedSuccessfully) {
            iframe.classList.remove('hidden')
          } else {
            this.loadingError = true
          }
        } catch {
          this.loadingError = true
        }
      }
    }
  }
</script>

<style scoped>
  iframe {
    height: 100%;
    width: 100%;
  }

  .fully-centered {
    display: flex;
    flex-direction: column;
    justify-content: center;
    text-align: center;

    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;

    .text {
      font-size: 1.3rem;
      margin-top: 5px;
    }
  }
</style>
