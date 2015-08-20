<issues>

  <div each={opts.prioritised_issues.entries} class={'priority-level p' + url}>
    <h4>Priority {title}</h4>
    <ul class='issues-list'>
      <!-- passes title to issue tag in opts object -->
    	<issue/>
    </ul>
  </div>
  
  <script>
  </script>
  

</issues>
