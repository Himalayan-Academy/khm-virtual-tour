<script>
  export let id;
  export let hero_image;
  export let about;
  export let title;
  export let description;
  export let x;
  export let y;

  const urlWithPrefix = (id, url) =>
    `/virtualtour/index.php/thumb/500/${id}/${url}`;

  const imageUrl = urlWithPrefix(id, hero_image);
</script>

<style>
  a {
    width: 33%;
    color: #000;
    outline: none;
    text-align: center;
  }

  @media only screen and (max-width: 800px) {
    a {
      width: 50%;
    }
  }

  a:visited {
    color: #000;
  }

  h1 {
    color: #8c3945;
  }

  img {
    border-radius: 20px;
    border: solid 3px #8c3945;
    max-width: 80%;
    max-height: 250px;
    overflow: hidden;
  }
</style>

<a href="?route=/location&location={id}">
  <h1>{title}</h1>
  <img src={imageUrl} alt={title} />
  <p>{about}</p>
</a>
