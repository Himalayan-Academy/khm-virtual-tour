<script>
import {navigate} from "./routes.js";
</script>

<style>
  ._142498f0 {
    flex: 1 1;
    font-family: Lato, sans-serif;
  }

  @media only screen and (min-width: 300px) and (max-width: 800px) {
    ._142498f0 {
      font-size: 18px;
    }
  }

  @media only screen and (min-width: 800px) {
    ._142498f0 {
      padding-left: 20px;
    }
  }

  ._4925b2e7 {
    list-style: none;
    display: flex;
    justify-content: space-around;
    vertical-align: middle;
    padding: 0px;
  }

  ._54a92c25 {
    padding-left: 15px;
    padding-right: 15px;
    padding-bottom: 5px;
    display: flex;
    justify-content: space-between;
    vertical-align: middle;
    cursor: pointer;
    text-decoration: none;
    outline: none;
    color: #fff;
    background-color: #8c3945;
    border: 0px;
  }

  ._54a92c25:visited {
    color: #fff;
  }

  ._9d701ca9 {
    padding-left: 4px;
  }

  ._c5d81cdb {
    display: flex;
    background-color: #8c3945;
    color: #fff;
    align-items: center;
    vertical-align: middle;
    justify-content: center;
  }

  @media only screen and (min-width: 800px) {
    ._c5d81cdb {
      flex-direction: row;
      height: 60px;
    }
  }

  @media only screen and (min-width: 300px) and (max-width: 800px) {
    ._c5d81cdb {
      flex-direction: column;
    }
  }

  ._d03ad334 {
    text-decoration: none;
    color: #fff;
  }
</style>

<nav class="_c5d81cdb">
  <h1 class="_142498f0">
    <a href="#/map" class="_d03ad334">Kauai's Hindu Monastery Virtual Tour</a>
  </h1>
  <ul class="_4925b2e7">
    <a class="_54a92c25" href="#" on:click={() => navigate("/map")}>
      <svg
        class="feather feather-map"
        fill="none"
        height="24"
        width="24"
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        viewBox="0 0 24 24">
        <svg
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="feather feather-map">
          <polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6" />
          <line x1="8" y1="2" x2="8" y2="18" />
          <line x1="16" y1="6" x2="16" y2="22" />
        </svg>
      </svg>
      <span class="_9d701ca9">Map</span>
    </a>
    <a class="_54a92c25" href="#" on:click={() => navigate("/galleries")}> 
      <svg
        class="feather feather-image"
        fill="none"
        height="24"
        width="24"
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        viewBox="0 0 24 24">
        <svg
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="feather feather-image">
          <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
          <circle cx="8.5" cy="8.5" r="1.5" />
          <polyline points="21 15 16 10 5 21" />
        </svg>
      </svg>
      <span class="_9d701ca9">Galleries</span>
    </a>
    <a class="_54a92c25" href="#" on:click|preventDefault={() => navigate("/about")}>
      <svg
        class="feather feather-info"
        fill="none"
        height="24"
        width="24"
        stroke="currentColor"
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        viewBox="0 0 24 24">
        <svg
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="feather feather-info">
          <circle cx="12" cy="12" r="10" />
          <line x1="12" y1="16" x2="12" y2="12" />
          <line x1="12" y1="8" x2="12" y2="8" />
        </svg>
      </svg>
      <span class="_9d701ca9">About</span>
    </a>
  </ul>
</nav>
