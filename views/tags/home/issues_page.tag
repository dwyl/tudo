<issues-page>
  <nav issue_amounts={number_per_priority}></nav>
  <issues prioritised_issues={opts.prioritised_issues}></issues>

	<script>
		this.number_per_priority = opts.prioritised_issues.reduce(function (numbers, level) {
			var index = isNaN(+level.priority) ? 6 : +level.priority - 1;
			numbers[index] = level.issues.length;
			return numbers;
		}, [0, 0, 0, 0, 0, 0]);
	</script>

</issues-page>
