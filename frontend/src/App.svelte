<script>
  import Navigation from "./Navigation.svelte"; 
  import { route } from "./routes";

  console.log("route", $route)

  const popState = (ev) => console.log("pop", ev)
</script>

<svelte:window onpopstate={popState}/>
<Navigation />
<svelte:component this={$route.view}/>