<script setup>
  import { useData } from 'vitepress'
  const { page, frontmatter } = useData()

  import PageComponent from '../components/PageComponent.vue'
</script>

<template>
  <PageComponent />
</template>
