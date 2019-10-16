<script>
  export let dataset;
  let index = 0;
  let currentVideo = false;
  let currentCaption = false;

  $: {
    currentVideo = dataset[index];
  }

  const goPrev = () => {
    if (index > 0) {
      index = index - 1;
    }
  };

  const goNext = () => {
    if (index < dataset.length) {
      index = index + 1;
    }
  };
</script>

<style>
  .tab {
    display: flex;
  }

  figure.hero {
    text-align: center;
    background: gray;
    padding: 0;
    margin: 0;
  }

  figure.hero video {
    height: 100%;
    max-height: 100%;
    max-width: 100%;
  }

  figure.hero div {
    width: 560px;
    height: 315px;
  }

  @media only screen and (max-width: 800px) {
    figure.hero {
      width: 100%;
      height: 100%;
      max-width: 100%;
      max-height: 100%;
      text-align: center;
      background: unset;
      padding: 0;
      margin: 0;
    }

    figure.hero video {
      width: 90%;
    }

    figure.hero iframe {
      width: 90%;
    }

    img.c-pointer {
      height: 24px;
    }

    .tab div {
      padding: 2px !important;
    }
  }

  .arrow-left {
    transform: rotate(180deg);
  }

  .tab div {
    padding: 10px;
    vertical-align: middle;
    margin: auto;
  }

  .embed-container {
    position: relative;
    padding-bottom: 56.25%;
    height: 0;
    overflow: hidden;
    max-width: 100%;
  }
</style>

<div class="tab">
  <div>
    <img
      class="c-pointer arrow-left"
      src="images/arrow-right.png"
      on:click={goPrev} />
  </div>
  <figure class="hero">
    {#if currentVideo.kind == 'video'}
      <video
        controls
        poster="/virtualtour/{currentVideo.poster}"
        src="/virtualtour/{currentVideo.video}" />
    {:else}
      <div class="embed-container">
        <iframe
          src="https://www.youtube.com/embed/{currentVideo.video}"
          frameborder="0"
          allow="autoplay; encrypted-media"
          allowfullscreen />
      </div>
    {/if}
  </figure>

  <div>
    <img class="c-pointer" src="images/arrow-right.png" on:click={goNext} />
  </div>
</div>
