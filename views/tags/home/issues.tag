<issues>

  <div each={opts.prioritised_issues} class={'priority-level p' + priority}>
    <a name={priority}><h4>Priority {priority}</h4></a>
    <ul class='issues-list'>
      <!-- passes title to issue tag in opts object -->
    	<issue each={issues} title={title} priority={parent.priority} url={url}/>
    </ul>
  </div>

  <script>
  </script>


</issues>
