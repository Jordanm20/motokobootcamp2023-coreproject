<script>
  export let post
  let [id, proposal] = post;
</script>

<div class="post-preview">
  <h3>{proposal['id']}:</h3>
  <p>Change website text to: {proposal['body']}</p>
  <p>Yes 👍: {proposal['votesFor']}</p>
  <p>No 👎:  {proposal['votesAgainst']}</p>

</div>

<style>
  .post-preview {
    width: 75%;
    color: white;
    background-color: gray;
    border-radius: 10px;
    margin-top: 0px;
    margin-bottom: 4vmin;
    transform: translateY(-120px);
  }
</style>