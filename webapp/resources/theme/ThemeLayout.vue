<script lang="ts" setup>
  import { useData } from 'vitepress'
  const { page, frontmatter } = useData()

  import NotFoundPage from './pages/NotFoundPage.vue'

  import HomePage from './pages/HomePage.vue'
  import CustomPage from './pages/CustomPage.vue'

  import ArticlePage from './pages/ArticlePage.vue'
</script>

<template>
  <NotFoundPage v-if="page.isNotFound" />

  <HomePage v-else-if="frontmatter.layout === 'home'" />
  <CustomPage v-else-if="frontmatter.layout === 'custom'" />

  <ArticlePage v-else />
</template>
