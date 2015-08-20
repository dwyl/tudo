<issues>

  <div each={opts.prioritised_issues} class={'priority-level p' + priority}>
    <h4>Priority {priority}</h4>
    <ul class='issues-list'>
      <!-- passes title to issue tag in opts object -->
    	<issue each={issues} title={title}/>
    </ul>
  </div>
  
  <script>
  </script>
  

</issues>
