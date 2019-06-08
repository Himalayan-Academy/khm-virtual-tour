<script>
  let locations = false;

  async function getLocations() {
    const res = await fetch(
      "http://dev.himalayanacademy.com/virtualtour/index.php/locations"
    );

    const data = await res.json();

    if (res.ok) {
      locations = data.locations.slice(0, 5);
    } else {
      console.error("Error fetching locations", res);
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

  .item {
    padding: 3px;
  }

  .arrow {
      width: 120px;
  }

  img {
    border-radius: 20px;
    border: solid 3px #8c3945;
    max-height: 80px;
    overflow: hidden;
  }
</style>

<div class="sliders">
  {#if locations}
    <a class="item arrow" href="#">
      <img
        src="http://dev.himalayanacademy.com/virtualtour/points-of-interest/arrow-l.svg"
        alt="left" />
    </a>
    {#each locations as location}
      <a class="item" href="?route=/location&location={location.id}">
        <img
          src="http://dev.himalayanacademy.com/virtualtour/index.php/thumb/500/{location.id}/{location.hero_image}"
          alt={location.title} />
      </a>
    {/each}
    <a class="item arrow" href="#">
      <img
        src="http://dev.himalayanacademy.com/virtualtour/points-of-interest/arrow-r.svg"
        alt="right"/>
    </a>
  {:else}
    <p>Loading</p>
  {/if}
</div>
