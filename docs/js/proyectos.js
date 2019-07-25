window.addEventListener('DOMContentLoaded', init)

const dataset = new Dataset()
const grouped = new Dataset()

const searchbar = document.getElementById('searchbar')

searchbar.addEventListener('keyup', function (event) {
  const search = event.target.value.toLowerCase()
  const data = dataset.get()
  const includes = data.filter(function (item) {
    return item.name.toLowerCase().includes(search)
  })
  renderProjects(includes)
})

function init() {
  const data_input = document.getElementById('data')
  data_input.remove()
  const data = JSON.parse(data_input.value)
  const group = groupByLetter(data)
  const alphabet = getAlphabet(data)
  dataset.set(data)
  dataset.deleteMissing('name')
  grouped.set(group)
  renderLettersFilter(alphabet)
  renderProjects(data)
}

function groupByLetter(data) {
  return data.reduce(function (group, item) {
    if (!item.name) {
      return group
    }
    const capital = getCapitalLetter(item.name)
    group[capital] = group[capital] || []
    group[capital].push(item)
    return group
  }, {})
}

function getAlphabet(data) {
  const names = data
    .map(function (item) { return item.name })
    .filter(function (name) { return name })

  const capitals = names.map(getCapitalLetter)

  const alphabet = capitals
    .reduce(function (alphabet, item) {
      !alphabet.includes(item) && alphabet.push(item)
      return alphabet
    }, [])
    .sort()
  return alphabet
}

function getCapitalLetter(str) {
  const pattern = /(?<=\d|\s|^|¿|"|#)[A-Za-z]/
  const eval = pattern.exec(str)
  return eval[0].toUpperCase()
}

function renderLettersFilter(letters) {
  const container = document.getElementById('filters')
  const filters = letters.map(function (letter) {
    const element = DOMUtils.createElement('button', {
      attrs: {
        class: 'bg-swirl text-chocolate font-bold mr-2 px-3 py-1 rounded uppercase mb-2 btn-filter',
        'data-letter': letter
      },
      children: [letter]
    })
    const render = DOMUtils.render(element)
    return DOMUtils.render(element)
  })
  filters.forEach(function (filter) {
    container.append(filter)
  })
  registerLettersFilterHandler(filters)
}

function registerLettersFilterHandler(filters) {
  const buttons = [].concat(document.querySelector('.btn-filter'), filters)
  const group = grouped.get()
  const data = dataset.get()
  buttons.forEach(function (button) {
    button.addEventListener('click', function (event) {
      const letter = event.currentTarget.dataset.letter
      renderProjects(letter ? group[letter] : data)
    })
  })
}

function renderProjects(data) {
  const container = document.getElementById('cards')
  const cards = data.map(renderProjectCard)
  container.innerHTML = ''
  cards.forEach(function (card) {
    container.append(card)
  })
}

function createProjectCard(project) {
  return DOMUtils.createElement('div', {
    attrs: {
      class: 'w-full md:w-1/2 project-card block px-1 mb-2 flex-shrink-0 flex-grow max-w-full',
    },
    children: [
      DOMUtils.createElement('a', {
        attrs: {
          class: 'rounded bg-white py-2 px-4 hover:shadow-2xl flex flex-col h-full',
          href: '/proyectos/' + project.uid
        },
        children: [
          DOMUtils.createElement('span', {
            attrs: {
              class: 'uppercase font-bold text-chocolate block flex-grow mb-2'
            },
            children: [project.name]
          }),
          DOMUtils.createElement('small', {
            attrs: {
              class: 'block text-right text-xs'
            },
            children: [
              String(project.organizations.length),
              ' ',
              DOMUtils.createElement('span', {
                attrs: {
                  class: 'text-gray-700'
                },
                children: [project.organizations.length === 1 ? 'organización participante' : 'organizaciones participantes']
              })
            ]
          })
        ]
      })
    ]
  })
}

function renderProjectCard(item) {
  const element = createProjectCard(item)
  return DOMUtils.render(element)
}
