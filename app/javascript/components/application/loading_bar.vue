<template>
  <span 
    :style="{ height, width: computedWidth }" 
    class="loading-bar" />
</template>

<script>
  export default {
    name: 'LoadingBar',
    props: {
      maxWidth: {
        default: 100,
        type: Number
      },
      minWidth: {
        default: 80,
        type: Number
      },
      height: {
        default: '1em',
        type: String
      },
      width: {
        default: null,
        type: String
      }
    },
    computed: {
      computedWidth() {
        return this.width || `${Math.floor((Math.random() * (this.maxWidth - this.minWidth)) + this.minWidth)}%`;
      }
    }
  }
</script>

<style lang="scss">
  .loading-bar {
    display: inline-block;
    position: static;
    overflow: hidden;
    vertical-align: middle;
    background-color: #DDDBDD;
    margin-left: 10px;
    margin-right: 10px;
    margin-top: 5px;
    border-radius: 4px;

    &::after {
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
      content: ' ';
    }

    @keyframes shimmer {
      100% { transform: translateX(100%) }
    }
  }
</style>