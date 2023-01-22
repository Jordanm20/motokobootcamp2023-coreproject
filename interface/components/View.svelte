<script>
  import Proposal from "./Proposal.svelte"
  import { get } from "svelte/store"
  import { daoActor, principal } from "../stores"
  async function get_all_proposals() {
    let dao = get(daoActor);
    if (!dao) {
      return
    }
    let res = await dao.get_all_proposals()
    console.log("Proposals", res)
    return res
  }
  let promise =  get_all_proposals()
</script>

{#if $principal}
  {#await promise}
  <div id="contenedor">
    <div id="barra">
      <div id="texto"></div>
    </div>
  </div>
  {:then proposals}
    <div id="proposals">
      <h1>Proposals</h1>
      {#each proposals as post}
        <Proposal {post} />
      {/each}
    </div>
  {:catch error}
    <p style="color: red">{error.message}</p>
  {/await}
{:else}
  <p class="example-disabled" style="color: black">Connect with plug wallet to access this example, we only support plug wallet</p>
{/if}

<style>
  h1 {
    color: white;
    font-size: 10vmin;
    font-weight: 700;
  }
  #proposals {
    display: flex;
    flex-direction: column;
    width: 100%;
    margin-left: 10vmin;
  }
  #barra {
    align-self: center;
    text-align: center;
    align-items: center;
    width: 0;
    height: 100%;
    -webkit-animation: progreso 5s linear infinite;
            animation: progreso 5s linear infinite;

    background: #eb7260;
}
#contenedor {
    width: 25em;
    height: 4em;
    align-self: center;
    align-items: center;
    text-align: center;
    border: 2px solid #eb7260;
}
#texto {
    font-size: 2em;
    font-weight: bold;
    line-height: 2em;

    width: 20px;
    height: 20px;
    align-self: center;
    align-items: center;
    text-align: center;
    color: #eb7260;

    mix-blend-mode: multiply;
}

#texto:after {
    content: '0%';
    -webkit-animation: porcentaje 5s linear infinite;
            animation: porcentaje 5s linear infinite;
}

@-webkit-keyframes progreso {
    0% {
        width: 0;
    }
    100% {
        width: 100%;
    }
}

@keyframes progreso {
    0% {
        width: 0;
    }
    100% {
        width: 100%;
    }
}

@-webkit-keyframes porcentaje {
    0% {
        content: '0%';
    }
    25% {
        content: '25%';
    }
    50% {
        content: '50%';
    }
    75% {
        content: '75%';
    }
    100% {
        content: '100%';
    }
}

@keyframes porcentaje {
    0% {
        content: '0%';
    }
    25% {
        content: '25%';
    }
    50% {
        content: '50%';
    }
    75% {
        content: '75%';
    }
    100% {
        content: '100%';
    }
}
</style>