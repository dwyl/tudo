<issue>
  <li>
    <div class={'issue-priority priority-'+opts.priority} ></div>
    <div class='issue-info'>
      <p class='issue-title'>{'[' + org + '/' + repo + ']' + opts.title} </p>
      <p>Latest activity: 2 hours ago</p>
    </div>
    <a href=https://www.github.com{opts.url}> &gt;</a>
  </li>
  <script>
    var urlChunks = opts.url.split('/');
    this.url = "https://www.github.com" + opts.url
    this.org = urlChunks[1];
    this.repo = urlChunks[2];
  </script>
</issue>
