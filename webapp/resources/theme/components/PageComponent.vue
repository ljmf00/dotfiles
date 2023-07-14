<script setup>
  import { useData } from 'vitepress'
  const { page, frontmatter } = useData()

  import HeaderComponent from './HeaderComponent.vue'
</script>

<style lang="scss">
  @import '../../sass/minimal/container';

  html, body {
    margin: 0px;
    padding: 0px;
    background-color: #f4f4f4;
    font-family: sans-serif;
  }

  #page {
    @extend .min-container;

    background-color: white;
    border: solid 1px #ccc;
  }
</style>

<template>
  <HeaderComponent />
  <aside />

  <main>
    <div id="page">
      <slot/>
    </div>
  </main>
</template>
