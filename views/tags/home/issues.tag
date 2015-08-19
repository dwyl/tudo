<issues>

  <div each={i in priority_levels} class={'priority-level p' + i}>
    <h4>Priority {i}</h4>
    <ul class='issues-list'>
    	<issue />
    </ul>
  </div>
  
  <script>
  this.priority_levels = [
    1,2,3,4,5
  ]
  </script>
  

</issues>
