(function () {
  var categoryPills = document.querySelectorAll('[data-filter-category]');
  var cards = document.querySelectorAll('.demo-card');
  var searchInput = document.getElementById('demo-search');
  var emptyState = document.getElementById('filter-empty');

  if (!cards.length) return;

  var activeCategory = 'all';

  function cardMatchesCategory(card, category) {
    if (category === 'all') return true;
    return card.dataset.category === category;
  }

  function cardMatchesSearch(card, query) {
    if (!query) return true;
    var haystack = (card.dataset.search || '').toLowerCase();
    return haystack.indexOf(query) >= 0;
  }

  function setActivePill(category) {
    categoryPills.forEach(function (pill) {
      pill.classList.toggle('active', pill.dataset.filterCategory === category);
    });
  }

  function applyFilters() {
    var query = searchInput ? searchInput.value.trim().toLowerCase() : '';
    var visibleCount = 0;

    cards.forEach(function (card) {
      var show =
        cardMatchesCategory(card, activeCategory) &&
        cardMatchesSearch(card, query);
      card.classList.toggle('hidden', !show);
      if (show) visibleCount += 1;
    });

    document.querySelectorAll('.section').forEach(function (section) {
      var visible = section.querySelectorAll('.demo-card:not(.hidden)').length;
      section.style.display = visible > 0 ? '' : 'none';
    });

    if (emptyState) {
      emptyState.classList.toggle('hidden', visibleCount > 0);
    }
  }

  categoryPills.forEach(function (pill) {
    pill.addEventListener('click', function () {
      activeCategory = pill.dataset.filterCategory;
      setActivePill(activeCategory);
      applyFilters();
    });
  });

  if (searchInput) {
    searchInput.addEventListener('input', applyFilters);
  }

  applyFilters();
})();
