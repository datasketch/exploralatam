window.addEventListener('DOMContentLoaded', function (event) {
  registerSearchOverlay()
})

function registerSearchOverlay () {
  const searchOverlay = document.getElementById('search-overlay')
  const searchTrigger = document.getElementById('search-trigger')
  const searchClose = Array.prototype.map.call(document.querySelectorAll('.search-close'), function (element) { return element })
  searchTrigger.addEventListener('click', function (event) {
    searchOverlay.classList.remove('hidden')
  })
  searchClose.forEach(function (element) {
    element.addEventListener('click', function (event) {
      event.preventDefault()
      searchOverlay.classList.add('hidden')
    })
  })
}
