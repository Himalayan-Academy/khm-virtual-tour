<script>
  export let dataset;
  let currentImageIndex = 0;
  let currentImage = false;
  let currentCaption = false;

  console.log("dataset", dataset)

  $: {
    currentImage = dataset[currentImageIndex].image;
    currentCaption = dataset[currentImageIndex].caption;
    console.log(dataset.length, currentImageIndex)
  }

  const goPrev = () => {
    if (currentImageIndex > 0) {
      currentImageIndex = currentImageIndex - 1;
    }
  };

  const goNext = () => {
    if (currentImageIndex < dataset.length - 1) {
      currentImageIndex = currentImageIndex + 1;
    }
  };
</script>

<style>
  .tab {
    display: flex;
  }

  figure.hero {
    width: 600px;
    height: 480px;
    max-width: 600px;
    max-height: 480px;
    text-align: center;
    background: #F3F1EA;
    background-image: url(/assets/img/bg-page.jpg);
    padding: 0;
    margin: 0;
  }

  figure.hero img {
    height: 100%;
    max-height: 100%;
    max-width: 100%;
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

    figure.hero img {
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

  a-scene {
    width: 640px;
    height: 480px;
  }
</style>

{#if dataset}
<div class="tab">
  <div>
    <img
      class="c-pointer arrow-left"
      src="images/arrow-right.png"
      on:click={goPrev} />
  </div>
  <a-scene embedded="true">
    <a-assets>
      {#each dataset as image, i}
        <img
          id="img-{i}"
          src="/virtualtour/{image.image}"
          crossorigin="anonymous"
          alt={image.caption} />
      {/each}
    </a-assets>
    <a-sky id="image-360" src="#img-{currentImageIndex}" rotation="0 -20 0" />
  </a-scene>
  <div>
    <img class="c-pointer" src="images/arrow-right.png" on:click={goNext} />
  </div>
</div>
{:else}
<p>loading...</p>
{/if}