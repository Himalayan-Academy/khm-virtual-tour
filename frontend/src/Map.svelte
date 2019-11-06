<script>
  import SocialButtons from "./SocialButtons.svelte";
  let map = {};
  let markers = {};
  let locations = false;

  let url = "/virtualtour/index.php"; //"//localhost:8081";

  console.log(`fetching locations...`);
  fetch(`${url}/locations`)
    .then(function(response) {
      return response.json();
    })
    .then(function(data) {
      locations = data.locations;
      console.log("building map...");
      map = L.map("mapid", {
        crs: L.CRS.Simple,
        zoom: 2
      });
      map.attributionControl.addAttribution(
        '<a href="/">Himalayan Academy Publications</a>'
      );

      var bounds = [[0, 0], [694, 1000]];
      var image = L.imageOverlay(
        "/virtualtour/points-of-interest/aadheenam-map-alpha.png",
        bounds
      ).addTo(map);
      map.fitBounds(bounds);

      console.dir(data);
      data.locations.forEach(location => {
        let coords = L.latLng([location.y, location.x]);
        markers[location.id] = L.marker(coords, {
          title: location.title,
          draggable: false
        })
          .on("move", d => {
            // // remove before final version
            // console.log("move", d.latlng);
            // fetch(`${url}/setposition/${location.id}/${d.latlng.lng}/${d.latlng.lat}`)
            //   .then(function (response) {
            //     return response.text();
            //   })
            //   .then(r => {
            //     console.log("server", r);
            //   });
          })
          .addTo(map).bindPopup(`
            <b>${location.title}</b>
            <br>
            <img style="max-width: 100%; max-height: 200px" src="/virtualtour/index.php/thumb/200/${
              location.id
            }/${location.hero_image}">
            <br>
            ${location.about} 
            <a href="index.html?route=/location&location=${
              location.id
            }">Learn more...</a>
            `);
      });
      console.log("markers", markers);

      console.log("all done");
    });
</script>

<style>
  .map {
    display: flex;
  }

  #mapid {
    flex: 1 1 auto;
    height: calc(100vh - 60px);
    background-color: #746e24;
    background-image: url("/virtualtour/points-of-interest/bg2.jpg");
    background-repeat: repeat;
  }

  .item-column {
    width: 15%;
    border-left: 3px solid #8c3945;
    background-color: #746e24;
    background-image: url("/virtualtour/points-of-interest/bg2.jpg");
    background-repeat: repeat;
  }

  @media only screen and (max-width: 800px) {
    .item-column {
      display: none;
    }

    .social-buttons {
      display: none;
    }
  }

  ul {
    list-style: none;
    color: rgb(250, 250, 250);
    padding-left: 10px;
    font-size: 1.2rem;
    height: calc(100vh - 60px);
    overflow-y: scroll;
    overflow-x: hidden;
    margin: 0px;
    background-color: rgba(0, 0, 0, 0.4);
  }

  li {
    cursor: pointer;
  }

  span a {
    text-decoration: none;
    color: rgb(250, 250, 250);
  }
</style>

<div class="map">
  <div id="mapid" />
  {#if !locations}
    <div />
  {:else}
    <div class="item-column">
      <ul>
        {#each locations as location}
          <li>
            <span>
              <a href="?route=/location&location={location.id}">
                 {location.title}
              </a>
            </span>
          </li>
        {/each}
      </ul>
    </div>
    <div class="social-buttons">
      <SocialButtons />
    </div>
  {/if}
</div>
