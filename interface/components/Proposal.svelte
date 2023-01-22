<script>
  export let post
  let [id, proposal] = post;
</script>

<div class="post-preview">
  <h3>{proposal['id']}:</h3>
  <p>Change website text to: {proposal['body']}</p>
  <p>Yes: {proposal['votesFor']}</p>
  <p>No:  {proposal['votesAgainst']}</p>
  <hr />

</div>

<style>
  .post-preview {
    border: 1px green;
    border-radius: 10px;
    margin-bottom: 8vmin;
  }
</style>