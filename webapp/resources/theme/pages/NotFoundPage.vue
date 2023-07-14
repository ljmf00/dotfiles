<script lang="ts" setup>
  import { useData } from 'vitepress'
  const { page, frontmatter } = useData()

  import PageComponent from '../components/PageComponent.vue'
  import TextBox from '../components/TextBox.vue'
</script>

<template>
  <PageComponent>
    <TextBox>Not found.</TextBox>
  </PageComponent>
</template>
