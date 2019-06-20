<script>
  let locations = false;

  export let currentPage = 0;
  let itemsPerPage = 5;

  let currentPageStart;
  let currentPageEnd;
  let currentPageLocations;

  async function getLocations() {
    const res = await fetch(
      "http://dev.himalayanacademy.com/virtualtour/index.php/locations"
    );

    const data = await res.json();

    if (res.ok) {
      locations = data.locations;
    } else {
      console.error("Error fetching locations", res);
    }
  }

  const prevPage = () => {
    if (currentPage > 0) {
      currentPage -= 1;
    }
  };

  const nextPage = () => {
    if (currentPage < Math.floor(locations.length / itemsPerPage) + 1) {
      currentPage += 1;
    }
  };

  $: {
    if (locations) {
      currentPageStart = itemsPerPage * currentPage;
      currentPageEnd = currentPageStart + itemsPerPage;
      currentPageLocations = locations.slice(currentPageStart, currentPageEnd);
      console.dir("selected locations", currentPageLocations);
    }
  }

  getLocations();
</script>

<style>
  .sliders {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100px;
    max-height: 100px;
    background-color: #8c3945;
    flex-wrap: nowrap;
    overflow-x: hidden;
  }

    @media only screen and (max-width: 800px) {
      .sliders {
        display: none;
      }
    }

  .item {
    padding: 3px;
  }

  img {
    max-height: 80px;
    overflow: hidden;
  }

  img.selector {
    border: solid 1px white;
  }
</style>

<div class="sliders">
  {#if locations}
    <a class="item arrow" href="#" on:click={prevPage}>
      <img
        src="images/left.png"
        alt="left" />
    </a>
    {#each currentPageLocations as location}
      <a class="item" href="?route=/location&location={location.id}">
        <img
          class="selector"
          src="http://dev.himalayanacademy.com/virtualtour/index.php/thumb/500/{location.id}/{location.hero_image}"
          alt={location.title} />
      </a>
    {/each}
    <a class="item arrow" href="#" on:click={nextPage}>
      <img
        src="images/right.png"
        alt="right" />
    </a>
  {:else}
    <p>Loading</p>
  {/if}
</div>
