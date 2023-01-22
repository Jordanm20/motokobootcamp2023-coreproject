<script>
  import { daoActor, principal } from "../stores"
  import { get } from "svelte/store"
  import mot from "../assets/mot.png"
  let choosenproposal = ""
  let summary
  async function create_proposal(summarypayload) {
    let dao = get(daoActor)
    if (!dao) {
      return
    }
    let res = await dao.submit_proposal(summarypayload)
    if (res.Ok) {
      return res.Ok
    } else {
      throw new Error(res.Err)
    }
  }
  let promise = create_proposal(summary)
  function handleCreateClick(payload) {
    summary = payload
    promise = create_proposal(summary)
  }
</script>

<div class="votemain">
  {#if $principal}
    <img src={mot} class="bg" alt="logo" />
    <h1 class="slogan">Create a proposal</h1>
    <input
      bind:value={choosenproposal}
      placeholder="Input your proposal summary here"
    />
    <button on:click={handleCreateClick(choosenproposal)}>Create!</button>
    {#await promise}
    <div id="contenedor">
    <div id="barra">
      <div id="texto"></div>
    </div>
  </div>

    {:then proposal}
      <p style="color: black">Proposal created with payload {proposal}</p>
    {:catch error}
      <p style="color: red">{error.message}</p>
    {/await}
  {:else}
    <p class="example-disabled" style="color: black">Connect with a wallet to access this example</p>
  {/if}
</div>

<style>
  input {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
  }
  .bg {
    height: 55vmin;
    animation: pulse 3s infinite;
  }
  .votemain {
    display: flex;
    flex-direction: column;
    justify-content: center;
  }
  button {
    background-color: #4caf50;
    border-radius: 3px;
    color: white;
    padding: 15px 32px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 4px 2px;
    cursor: pointer;
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