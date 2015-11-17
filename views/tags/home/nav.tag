<nav>
  <ul class='priority-nav'>
    <li class='priority-tab' each={num, index in opts.issue_amounts}>
      <a href=#{indexTranslate(index)}>
        P{indexTranslate(index)} [{num}]
      </a>
    </li>
  </ul>
  <p class='filter-icon'>Filter</p>
  <script>
    this.indexTranslate = function (index) {
      return index < 5 ? index + 1 : 'U'
    }
  </script>
</nav>
