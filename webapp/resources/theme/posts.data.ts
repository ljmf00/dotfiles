import { type PostMetadata, createPostsLoader } from './src/posts'

// data reactive object
declare const data: PostMetadata[]
export      { data }

// post loader
export default createPostsLoader()
