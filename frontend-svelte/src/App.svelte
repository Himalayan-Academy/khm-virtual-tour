<script>
  import Navigation from "./Navigation.svelte"; 
  import { route } from "./routes";

  console.log("route", $route)
</script>

<Navigation />
<svelte:component this={$route.view}/>