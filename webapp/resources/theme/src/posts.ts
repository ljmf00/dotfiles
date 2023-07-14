import { createContentLoader, useData } from 'vitepress'

export interface PostMetadata
{
    // post id
    id: string
    // post title
    title: string
    // post relative url
    url: string
    // date of the post
    date: Date
    // excerpt, if exists
    excerpt?: string
}

export function createPostsLoader()
{
    return createContentLoader('resources/content/posts/*.md', {
        excerpt: true,
        transform(raw): Post[] {
            return raw
                .map(({ url, frontmatter, excerpt }) => ({
                  title: frontmatter.title,
                  url: `posts/${url.split(/(\\|\/)/g).pop()}`,
                  excerpt,
                  date: formatDate(frontmatter.date)
                }))
                .sort((a, b) => b.date.time - a.date.time)
        }
    })
}

function formatDate(raw: string)
{
    const date = new Date(raw)
    date.setUTCHours(12)
    return +date
}
