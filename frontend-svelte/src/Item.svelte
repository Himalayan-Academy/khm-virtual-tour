<script>
  import { parseLocation } from "./routes.js";
  import GallerySlider from "./GallerySlider.svelte";
  import Slideshow from "./Slideshow.svelte";
  import Panoramas from "./Panoramas.svelte";
  import Videos from "./Videos.svelte";

  let location = false;

  let tabs = {
    slideshow: Slideshow,
    panoramas: Panoramas,
    videos: Videos,
    drone: Videos
  };

  let datasets;

  let activeTab = "slideshow";
  let currentTab;
  let currentDataset;

  async function getLocation(id) {
    console.log("id", id);
    const res = await fetch(
      `/virtualtour/index.php/location/${id}`
    );

    const data = await res.json();

    if (res.ok) {
      location = data.location;
      document.title = `${
        location.metadata.title
      } - Kauai Hindu Monastery Virtual Tour`;
      datasets = {
        slideshow: location.slideshows,
        panoramas: location.panoramas,
        videos: location.videos,
        drone: location["quad-videos"]
      };
    } else {
      console.error("Error fetching locations", res);
    }
  }

  const params = parseLocation();

  getLocation(params.location);

  $: {
    console.log("activeTab", activeTab);
    currentTab = tabs[activeTab];
    if (datasets) {
      currentDataset = datasets[activeTab];
    }
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
            <svelte:component this={currentTab} dataset={currentDataset} />
            <p class="show-mobile">{location.metadata.description}</p>

            <img
              class="feet"
              src="/virtualtour/points-of-interest/feet.svg"
              alt="decoration" />
          </div>
          <div class="tab-switcher">
            {#if location['quad-videos'][0]}
              <div>
                <img
                  src="images/drone-icon.png"
                  alt="drone videos"
                  class:active={activeTab == 'drone'}
                  on:click={() => (activeTab = 'drone')} />
              </div>
            {/if}

            {#if location.panoramas[0]}
              <div>
                <img
                  src="images/360-icon.png"
                  alt="360 videos"
                  class:active={activeTab == 'panoramas'}
                  on:click={() => (activeTab = 'panoramas')} />
              </div>
            {/if}

            {#if location.slideshows[0]}
              <div>
                <img
                  src="images/slideshow-icon.png"
                  alt="slideshows"
                  class:active={activeTab == 'slideshow'}
                  on:click={() => (activeTab = 'slideshow')} />
              </div>
            {/if}

            {#if location.videos[0]}
              <div>
                <img
                  src="images/camera-icon.png"
                  alt="videos"
                  class:active={activeTab == 'videos'}
                  on:click={() => (activeTab = 'videos')} />
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
