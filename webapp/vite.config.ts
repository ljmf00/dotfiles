import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import { ViteMinifyPlugin } from 'vite-plugin-minify';
import manifestSRI from 'vite-plugin-manifest-sri';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/sass/style.scss', 'resources/css/app.css', 'resources/js/app.js'],
            buildDirectory: 'bundle',
            refresh: true,
        }),
        manifestSRI(),
        ViteMinifyPlugin({}),
    ],
});
