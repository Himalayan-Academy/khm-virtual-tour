<script>
  import GalleryItem from "./GalleryItem.svelte";
  import Pagination from "./Pagination.svelte";

  const itemsPerPage = 12;
  let currentPage = 0;
  let totalNumberOfItems = 0;

  let promise = getLocations();

  async function getLocations() {
    const res = await fetch(
      "http://dev.himalayanacademy.com/virtualtour/index.php/locations"
    );

    const data = await res.json();

    if (res.ok) {
      totalNumberOfItems = data.locations.length;
      return data.locations;
    } else {
      throw new Error(data);
    }
  }

  const itemsForCurrentPage = locations => {
    let start = currentPage * itemsPerPage;
    let end = start + itemsPerPage;

    return locations.slice(start, end);
  };

  const paginate = event => {
    currentPage = event.detail.page;
    console.log("want page:", currentPage);
  };
</script>

<style>
  div {
    display: flex;
    flex-wrap: wrap;
  }
</style>

<div>
  {#await promise}
    <p>Loading...</p>
  {:then locations}
    {#each itemsForCurrentPage(locations) as location (location.id)}
      <GalleryItem {...location} />
    {/each}
    <Pagination
      {itemsPerPage}
      {currentPage}
      {totalNumberOfItems}
      on:paginate={paginate} />
  {:catch}
    <p>An error happened fetching our locations...</p>
  {/await}
</div>
