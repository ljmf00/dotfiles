import { type EnhanceAppContext } from 'vitepress'
import Layout from './ThemeLayout.vue'

export default {
    Layout,
    enhanceApp({ app, router, siteData }: EnhanceAppContext) {
        // app is the Vue 3 app instance from `createApp()`. router is VitePress'
        // custom router. `siteData`` is a `ref`` of current site-level metadata.
    }
}
