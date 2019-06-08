<script>
  import { parseLocation } from "./routes.js";
  import GallerySlider from "./GallerySlider.svelte";

  let location = false;

  async function getLocation(id) {
    console.log("id", id);
    const res = await fetch(
      `http://dev.himalayanacademy.com/virtualtour/index.php/location/${id}`
    );

    const data = await res.json();

    if (res.ok) {
      location = data.location;
      document.title = `${
        location.metadata.title
      } - Kauai Hindu Monastery Virtual Tour`;
    } else {
      console.error("Error fetching locations", res);
    }
  }

  const params = parseLocation();

  getLocation(params.location);

  $: {
    console.log("location", location);
  }
</script>

<style>
  .flex {
    display: flex;
    flex-direction: column;
    flex-wrap: nowrap;
    height: calc(100vh - 60px);
    max-height: calc(100vh - 60px);
  }

  .main-display {
    flex: 1 1 auto;
    align-self: auto;
    display: flex;
    height: calc(100vh - 180px);
    max-height: calc(100vh - 160px);
  }

  .current-tab {
    display: flex;
    flex-direction: column;
    align-items: center;
    vertical-align: top;
    justify-content: center;
    overflow: scroll;
  }

  .current-tab figure.hero {
    max-height: 40%;
    max-width: 60%;
    text-align: center;
  }

  figure.hero img {
    border-radius: 20px;
    border: 3px solid #8c3945;
    max-width: 100%;
    max-height: 100%;
  }

  .current-tab img.feet {
    width: 70%;
    padding: 20px;
  }

  .current-tab p {
    font-size: 16px;
    padding: 10px;
  }

  .tab-switcher {
    width: 15%;
    min-width: 15%;
    background-color: #b7c1c1;
    display: flex;
    flex-direction: column;
  }

  .tab-switcher div {
    display: flex;
    align-items:center;

  }

  @media only screen and (max-width: 800px) {
    .tab-switcher {
      display: none;
    }
    .mobile-menu {
      display: block;
    }
  }

  .arrow-1 {
    margin-left: -150px;
    max-height: 120px;
  }

  .tab-item {
    border: 2px solid white;
    max-height: 60px;
    margin-right: 10px;
  }

  h1 {
    color: rgb(140, 57, 69);
    font-family: Lato, sans-serif;
    font-size: 36px;
  }
</style>

<div class="container flex">
  {#if location}
    <div class="main-display">
      <div class="container current-tab">
        <h1>{location.metadata.title}</h1>
        <p>{location.metadata.description}</p>
        <figure class="hero">
          <img
            src="http://dev.himalayanacademy.com/virtualtour/{location.metadata.hero_image}"
            alt={location.metadata.title} />
        </figure>
        <img
          class="feet"
          src="http://dev.himalayanacademy.com/virtualtour/points-of-interest/feet.svg"
          alt="decoration" />
      </div>
      <div class="tab-switcher">
        {#if location['quad-videos'][0]}
        <div>
          <img
            class="arrow-1"
            src="http://dev.himalayanacademy.com/virtualtour/points-of-interest/arrow_1.svg"
            alt="decoration" />
          <img
            src="http://img.youtube.com/vi/{location['quad-videos'][0].video}/maxresdefault.jpg"
            class="tab-item" />
        </div>
        {/if}

        {#if location.panoramas[0]}
        <div>
          <img
            class="arrow-1"
            src="http://dev.himalayanacademy.com/virtualtour/points-of-interest/arrow_2.svg"
            alt="decoration" />
          <img
            src="http://dev.himalayanacademy.com/virtualtour/{location.panoramas[0].image}"
            class="tab-item" />
        </div>
        {/if}

        {#if location.slideshows[0]}
        <div>
          <img
            class="arrow-1"
            src="http://dev.himalayanacademy.com/virtualtour/points-of-interest/arrow_3.svg"
            alt="decoration" />
          <img
            src="http://dev.himalayanacademy.com/virtualtour/{location.slideshows[0].image}"
            class="tab-item" />
        </div>
        {/if}

        {#if location.videos[0]}
        <div>
          <img
            class="arrow-1"
            src="http://dev.himalayanacademy.com/virtualtour/points-of-interest/arrow_4.svg"
            alt="decoration" />
          <img
            src="http://img.youtube.com/vi/{location.videos[0].video}/maxresdefault.jpg"
            class="tab-item" />
        </div>
        {/if}
      </div>

    </div>
    <GallerySlider class="sliders" />
  {:else}
    <p>Loading...</p>
  {/if}
</div>
