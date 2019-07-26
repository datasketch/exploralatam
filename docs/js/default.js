let header, menuOverlay

window.addEventListener('DOMContentLoaded', function (event) {
  header = document.querySelector('header')
  menuOverlay = document.getElementById('menu-overlay')
  registerSearchOverlay()
  registerMenuOverlay()
  readData()
})

window.addEventListener('resize', function (event) {
  setOverlayPadding()
})

function registerSearchOverlay() {
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

function registerMenuOverlay() {
  setOverlayPadding()
  const menuTrigger = document.getElementById('menu-trigger')
  menuTrigger.addEventListener('click', function (event) {
    const target = event.currentTarget
    const burger = target.querySelector('button.hamburger')
    burger.classList.toggle('is-active')
    menuOverlay.classList.toggle('hidden')
  })
}

function setOverlayPadding() {
  const headerHeight = header.offsetHeight
  menuOverlay.style.paddingTop = headerHeight + 'px'
}

function readData() {
  const projectsInput = document.getElementById('projects')
  const organizationsInput = document.getElementById('organizations')
  projectsInput.remove()
  organizationsInput.remove()
  const projects = JSON.parse(projectsInput.value)
  const organizations = JSON.parse(organizationsInput.value)
  const projectsCount = projects
    .filter(function (project) {
      return project.name
    })
    .length
  const organizationsCount = organizations
    .filter(function (organization) {
      return organization.name
    })
    .length
  document.getElementById('projects_count').textContent = projectsCount
  document.getElementById('organizations_count').textContent = organizationsCount
}