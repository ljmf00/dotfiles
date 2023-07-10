<script setup>
  import { useData } from 'vitepress'
  const { page } = useData()
</script>

<template>
  <div v-if="page.isNotFound">
    <pre>Not found.</pre>
  </div>
  <Content v-else />
</template>
