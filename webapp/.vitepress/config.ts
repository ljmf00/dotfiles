import { defineConfig } from 'vitepress';
import eslint from 'vite-plugin-eslint';
import manifestSRI from 'vite-plugin-manifest-sri';

export default defineConfig({
    lang: 'en-US',
    title: 'luis space',
    srcDir: './resources/content',
    outDir: './public',
    vite: {
        plugins: [
            eslint(),
            manifestSRI(),
        ],
        build: {
            minify: 'terser',
            cssMinify: 'lightningcss',
            terserOptions: {
                ecma: 2015,
            },
            target: 'es2015',
        }
    },
});
