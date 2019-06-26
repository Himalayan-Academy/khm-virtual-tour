<script>
  import { parseLocation } from "./routes.js";
  import GallerySlider from "./GallerySlider.svelte";
  import Slideshow from "./Slideshow.svelte";

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
    padding-left: 25px;
  }

  .tab-switcher div {
    flex: 1 1 auto;
    text-align: center;
  }

  .tab-switcher img.active {
    border: solid 6px maroon;
    border-radius: 50%;
    padding: 8px;
  }

  .tab-switcher img {
    width: 80px;
    max-width: 80px;
  }

  .tab-switcher img:hover {
    cursor: pointer;
  }

  @media only screen and (max-width: 800px) {
    .main-column {
      width: 100%;
      padding: 5px;
    }

    figure.hero {
      width: 100%;
      height: 100%;
      max-width: 100%;
      max-height: 100%;
      text-align: center;
      background: unset;
      padding: 0;
      margin: 0;
    }

    figure.hero img {
      width: 90%;
    }

    .tab-and-switcher {
      flex-direction: column-reverse;
    }

    .tab-switcher {
      flex-direction: row;
      order: 0;
      width: 100%;
      align-items: center;
      padding-bottom: 10px;
      padding-left: unset;
    }

    h1 {
      text-align: center;
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
        <p class="show-desktop">{location.metadata.description}</p>
        <div class="tab-and-switcher">
          <div clas="tab">
            <Slideshow images={location.slideshows}></Slideshow>
            <p class="show-mobile">{location.metadata.description}</p>

            <img
              class="feet"
              src="http://dev.himalayanacademy.com/virtualtour/points-of-interest/feet.svg"
              alt="decoration" />
          </div>
          <div class="tab-switcher">
            {#if location['quad-videos'][0]}
              <div>
                <img
                  class="active"
                  src="images/drone-icon.png"
                  alt="drone videos" />
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
