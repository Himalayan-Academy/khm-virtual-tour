<script>
  export let itemsPerPage;
  export let currentPage;
  export let totalNumberOfItems;

  import { createEventDispatcher } from "svelte";

  const dispatch = createEventDispatcher();

  const paginate = i => {
      console.log("pagination!", i)
      dispatch("paginate", {page: i})
  }

  const arr = Array.apply(null, { length: Math.floor(totalNumberOfItems / itemsPerPage) }).map(
    Number.call,
    Number
  );
</script>

<style>
  .pagination {
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    width: 100%;
  }

  span {
    font-size: 1.3rem;
    color: #000;
    width: 80px;
    text-decoration: none;
  }

  a {
    font-size: 1.3rem;
    color: #8c3945;
    width: 80px;
    text-decoration: none;
  }
</style>

<div class="pagination">
  {#each arr as i}
    {#if i == currentPage}
      <span>{i}</span>
    {:else}
      <a href="#/galleries/{i}" on:click={() => paginate(i)}>{i}</a>
    {/if}
  {/each}
</div>
