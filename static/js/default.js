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
    event.preventDefault()
    searchOverlay.classList.remove('hidden')
  })
  searchClose.forEach(function (element) {
    element.addEventListener('click', function (event) {
      event.preventDefault()
      searchOverlay.classList.add('hidden')
      document.getElementById('metasearch').value = ''
    })
  })
}

function registerMenuOverlay() {
  setOverlayPadding()
  const menuTrigger = document.getElementById('menu-trigger')
  menuTrigger.addEventListener('click', function (event) {
    event.preventDefault()
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
  // Menu
  const projectsInput = document.getElementById('projects')
  const organizationsInput = document.getElementById('organizations')
  projectsInput.remove()
  organizationsInput.remove()
  const projects = JSON.parse(projectsInput.value)
  const organizations = JSON.parse(organizationsInput.value)
  // Search
  const metaSearch = document.getElementById('metasearch')
  const projectsResult = document.getElementById('projects_results')
  const projectsShowcase = document.getElementById('projects_showcase')
  const organizationsResult = document.getElementById('organizations_results')
  const organizationsShowcase = document.getElementById('organizations_showcase')
  metaSearch.addEventListener('keyup', function (event) {
    // Reset on every keyup.
    const matches = { projects: [], organizations: [] }
    projectsResult.innerHTML = ''
    organizationsResult.innerHTML = ''
    projectsShowcase.classList.add('hidden')
    organizationsShowcase.classList.add('hidden')

    // search pipeline
    const search = event.target.value.toLowerCase()
    if (search) {
      matches.projects = projects.filter(function (project) {
        return project.name.toLowerCase().includes(search)
      }),
        matches.organizations = organizations.filter(function (organization) {
          return organization.name.toLowerCase().includes(search)
        })
    }
    // render projects results
    if (matches.projects.length) {
      const projectsLi = matches.projects.slice(0, 7).map(renderProjectLi)
      projectsLi.forEach(function (li) {
        projectsResult.append(li)
      })
      projectsShowcase.classList.remove('hidden')
    }
    // render organizations results
    if (matches.projects.length) {
      const organizationsLi = matches.organizations.slice(0, 7).map(renderOrganizationLi)
      organizationsLi.forEach(function (li) {
        organizationsResult.append(li)
      })
      organizationsShowcase.classList.remove('hidden')
    }
  })
}

function renderLiElement(item, type) {
  const li = DOMUtils.createElement('li', {
    attrs: {
      class: 'mb-4'
    },
    children: [
      DOMUtils.createElement('a', {
        attrs: {
          href: '/' + type + '/' + item.uid
        },
        children: [item.name]
      })
    ]
  })
  return DOMUtils.render(li)
}

function renderProjectLi(item) {
  return renderLiElement(item, 'proyectos')
}

function renderOrganizationLi(item) {
  return renderLiElement(item, 'organizaciones')
}