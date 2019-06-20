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
  }

  .main-content {
    flex: 1 1 auto;
    align-self: auto;
    display: flex;
  }

  .main-column {
    width: 700px;
    margin: auto;
  }

  .tab-and-switcher {
    display: flex;
  }

  .tab {
    flex: 1 1 auto;
  }

  figure.hero {
    width: 600px;
    height: 480px;
    max-width: 600px;
    max-height: 480px;
    text-align: center;
    background: gray;
    padding: 0;
    margin: 0;
  }

  figure.hero img {
    height: 100%;
    max-height: 100%;
    max-width: 100%;
  }

 

  img.feet {
    margin: 20px;
  }

  .tab-switcher {
    width: 100px;
    min-width: 100px;
    align-items: center;
    display: flex;
    flex-direction: column;
  }

  .tab-switcher div {
    flex: 1 1 auto;
    text-align: center;
  }

  .tab-switcher img {
    width: 80px;
    max-width: 80px;
  }

   .tab-switcher img:hover {
    cursor: pointer;
  }

  @media only screen and (max-width: 800px) {
    img.logo {
      display: none;
    }

    .tab-and-switcher {
      flex-direction: column-reverse;
    }

    .tab-switcher {
      flex-direction: row;
      order: 0;
      width: 100%;
      align-items: center;
    }
  }

  h1 {
    color: rgb(140, 57, 69);
    font-family: Lato, sans-serif;
    font-size: 36px;
  }
</style>

<div class="flex">
  {#if location}
    <div class="main-content">
      <div class="main-column">
        <h1>{location.metadata.title}</h1>
        <p>{location.metadata.description}</p>
        <div class="tab-and-switcher">
          <div clas="tab">
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
                <img src="images/drone-icon.png" alt="drone videos" />
              </div>
            {/if}

            {#if location.panoramas[0]}
              <div>
                <img src="images/360-icon.png" alt="360 videos" />
              </div>
            {/if}

            {#if location.slideshows[0]}
              <div>
                <img src="images/slideshow-icon.png" alt="slideshows" />
              </div>
            {/if}

            {#if location.videos[0]}
              <div>
                <img src="images/camera-icon.png" alt="videos" />
              </div>
            {/if}
          </div>
        </div>
      </div>
    </div>
    <GallerySlider />
  {:else}
    <p>Loading...</p>
  {/if}
</div>

