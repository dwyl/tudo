<issue>
  <li>
    <div class={'issue-priority priority-'+opts.priority} ></div>
    <div class='issue-info'>
      <p class='issue-title'>{'[' + org + '/' + repo + ']' + opts.title} </p>
      <p>Latest activity: 2 hours ago</p>
    </div>
    <!-- string concatenation doesn't work whether tried inline or on this.url -->
    <a href=https://www.github.com{opts.url}> &gt;</a>
  </li>
  <script>
    var urlChunks = opts.url.split('/');
    this.org = urlChunks[1];
    this.repo = urlChunks[2];
  </script>
</issue>
