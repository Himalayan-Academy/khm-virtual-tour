# Kauai Monastery Virtual Tour

This is the new version of the [Kauai Monastery Virtual Tour](http://dev.himalayanacademy.com/virtualtour). We've moved our frontend system to [Svelte](https://svelte.dev) because it is a better fit for our practices and knowledge. Our previous system which used [Elm](https://elm-lang.org) made it harder to cope with our changing requirements, the move to Svelte and back to using HTML/CSS/JS makes it easier for us to iterate.

Svelte is a proven technology in the same space of _react, vue and angular_ but much easier to use as its components ressemble normal HTML5 code. It is used in thousands if not millions of devices world-wide and performs really well.

This is our first iteration using Svelte, it is easier to maintain than our older version and allows us to be flexible enough to cope with design and model changes.

---

Below is the readme to learn how to work with svelte.

# svelte app

This is a project template for [Svelte](https://svelte.dev) apps. It lives at https://github.com/sveltejs/template.

To create a new project based on this template using [degit](https://github.com/Rich-Harris/degit):

```bash
npx degit sveltejs/template svelte-app
cd svelte-app
```

*Note that you will need to have [Node.js](https://nodejs.org) installed.*


## Get started

Install the dependencies...

```bash
cd svelte-app
npm install
```

...then start [Rollup](https://rollupjs.org):

```bash
npm run dev
```

Navigate to [localhost:5000](http://localhost:5000). You should see your app running. Edit a component file in `src`, save it, and reload the page to see your changes.


