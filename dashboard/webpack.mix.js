const mix = require("laravel-mix");
const path = require("path");
const tailwindcss = require("tailwindcss");
const { styles } = require("@ckeditor/ckeditor5-dev-utils");
const CKERegex = {
    svg: /ckeditor5-[^/\\]+[/\\]theme[/\\]icons[/\\][^/\\]+\.svg$/,
    css: /ckeditor5-[^/\\]+[/\\]theme[/\\].+\.css/,
};

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel applications. By default, we are compiling the CSS
 | file for the application as well as bundling up all the JS files.
 |
 */

Mix.listen("configReady", (webpackConfig) => {
    const rules = webpackConfig.module.rules;
    const targetSVG = /(\.(png|jpe?g|gif|webp)$|^((?!font).)*\.svg$)/;
    const targetFont = /(\.(woff2?|ttf|eot|otf)$|font.*\.svg$)/;
    const targetCSS = /\.p?css$/;

    for (let rule of rules) {
        if (rule.test.toString() === targetSVG.toString()) {
            rule.exclude = CKERegex.svg;
        } else if (rule.test.toString() === targetFont.toString()) {
            rule.exclude = CKERegex.svg;
        } else if (rule.test.toString() === targetCSS.toString()) {
            rule.exclude = CKERegex.css;
        }
    }
});

mix.alias({
    "@": path.join(__dirname, "resources/app"),
    "~": path.join(__dirname, "node_modules"),
});

mix
    .js("resources/app/app.js", "public/js")
    .vue()
    .sass("resources/app/assets/sass/app.scss", "public/css")
    .options({
        processCssUrls: false,
        postCss: [tailwindcss("./tailwind.config.js")],
    })
    .autoload({
        "cash-dom": ["cash"],
        "@popperjs/core": ["Popper"],
    })
    .webpackConfig({
        module: {
            rules: [
                {
                    test: CKERegex.svg,
                    use: ["raw-loader"],
                },
                {
                    test: CKERegex.css,
                    use: [
                        {
                            loader: "style-loader",
                            options: {
                                injectType: "singletonStyleTag",
                                attributes: {
                                    "data-cke": true,
                                },
                            },
                        },
                        "css-loader",
                        {
                            loader: "postcss-loader",
                            options: {
                                postcssOptions: styles.getPostCssConfig({
                                    themeImporter: {
                                        themePath: require.resolve(
                                            "@ckeditor/ckeditor5-theme-lark"
                                        ),
                                    },
                                    minify: true,
                                }),
                            },
                        },
                    ],
                },
            ],
        },
    })
    .browserSync({
        proxy: "midone-vue-laravel.test",
        files: ["resources/**/*.*"],
    });
