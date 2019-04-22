var map = {};
var markers = {};

var app = Elm.Main.init({
  node: document.getElementById("application")
});

function changeCurrentPanorama(pPanoramaImageID) {
  var el = document.querySelector("a-sky");

  el.setAttribute("src", pPanoramaImageID);
}

function unloadMapAndRedirect(pURL) {
  var el = document.querySelector("#mapid");
  if (el !== null) {
    el.innerHTML = "";
  }
  window.location = pURL;
}

app.ports.changePanoramaImage.subscribe(function (index) {
  changeCurrentPanorama(`#img-${index}`);
  console.log(`changed panorama to: #img-${index}`);
});

app.ports.popMarker.subscribe(function (id) {
  console.log("popping!", id);
  markers[id].togglePopup();
});

app.ports.unloadMap.subscribe(function () {
  console.log(`unloading map`);
  if (map.off && map.remove) {
    try {
      map.off();
      map.remove();
      map == null;
    } catch (n) {
      console.log("tried unloading an already unloaded ma p...");
    }
  } else {
    console.log('already unloaded?');
  }
});

app.ports.initializeMap.subscribe(function () {
  let url = "http://dev.himalayanacademy.com/virtualtour/index.php" //"http://localhost:8081";

  console.log(`fetching locations...`);
  fetch(`${url}/locations`)
    .then(function (response) {
      return response.json();
    })
    .then(function (data) {
      console.log("building map...")
      map = L.map('mapid', {
        crs: L.CRS.Simple,
        zoom: 2
      });
      map.attributionControl.addAttribution('<a href="/">Himalayan Academy Publications</a>');

      var bounds = [[0, 0], [694, 1000]];
      var image = L.imageOverlay(
        'http://dev.himalayanacademy.com/virtualtour/points-of-interest/aadheenam-map-alpha.png', bounds).addTo(map);
      map.fitBounds(bounds);

      console.dir(data)
      data.locations.forEach(location => {
        let coords = L.latLng([location.y, location.x]);
        markers[location.id] = L.marker(coords, { title: location.title, draggable: false })
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
          .addTo(map)
          .bindPopup(`
            <b>${location.title}</b>
            <br>
            <img style="max-width: 100%; max-height: 200px" src="http://dev.himalayanacademy.com/virtualtour/index.php/thumb/200/${location.id}/${location.hero_image}">
            <br>
            ${location.about} <a href="#/location/${location.id}">Learn more...</a>
            `);

      });
      console.log("markers", markers)

      console.log("all done")
    });
});