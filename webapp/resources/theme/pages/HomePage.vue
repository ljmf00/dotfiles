<script setup>
  import { useData } from 'vitepress'
  const { page, frontmatter } = useData()
  import { data as posts } from '../posts.data'

  import PageComponent from '../components/PageComponent.vue'
  import PostsListComponent from '../components/PostsListComponent.vue'
</script>

<template>
  <PageComponent>
    <PostsListComponent :posts="posts" />
  </PageComponent>
</template>
