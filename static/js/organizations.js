window.addEventListener('DOMContentLoaded', init)

function init() {
  const data_input = document.getElementById('data')
  let data = JSON.parse(data_input.value)
  data_input.remove()
  const group = groupByLetter(data)
  const alphabet = getAlphabet(data)
  renderLettersFilter(alphabet)
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
  const pattern = /(?<=\d|\s|^|¿|")[A-Za-z]/
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
  buttons.forEach(function (button) {
    button.addEventListener('click', function (event) {
      const letter = event.currentTarget.dataset.letter
      filterOrganizations(letter)
    })
  })
}

function filterOrganizations(filter) { }