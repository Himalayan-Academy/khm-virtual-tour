<script>
  import { parseLocation } from "./routes.js";

  let promise = getLocations();

  let locations = false;
  let location = false;

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

  async function getLocation(id) {
    console.log("id", id);
    const res = await fetch(`http://dev.himalayanacademy.com/virtualtour/index.php/location/${id}`);
    
    const data = await res.json();

    if (res.ok) {
      location = data.location;
    } else {
      console.error("Error fetching locations", res);
    }
  }

  const params = parseLocation();

  getLocation(params.location);
  getLocations();

  $: {
    console.log("location", location);
    console.log("locations", locations);
  }
</script>

<div />
