<script lang="ts" setup>
  import type { PostMetadata } from '../src/posts.ts'
  import TextBox from './TextBox.vue'

  defineProps<{
    posts: PostMetadata[]
  }>()
</script>

<template>
  <TextBox
    v-if="posts?.length"
    class="posts on-list"
  >
    <template v-for="post in posts" :key="post.id">
      <div class="post-meta">
        <h2 class="post-title">
          <a :href="post.url">{{ post.title }}</a>
        </h2>
        <div v-html="post.excerpt"/>
      </div>
    </template>
  </TextBox>
  <div v-else>
    <TextBox>Nothing to see here. Check my <a href="about">about page</a>!</TextBox>
  </div>
</template>
