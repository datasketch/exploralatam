window.addEventListener('DOMContentLoaded', function () {
  const app = new Vue({
    el: '#app',
    mounted: function() {
      const self = this
      const input = document.getElementById('data')
      this.data = JSON.parse(input.value)
      this.data = this.data.filter(function (item) {
        return item.name
      })
      .map(function (item) {
        item.capital = self.getCapitalLetter(item.name)
        return item
      })
      input.remove()
      this.$el.removeAttribute('hidden')
    },
    data: {
      data: [],
      letter: '',
      query: ''
    },
    computed: {
      filteredData: function() {
        if (!(this.letter || this.query)) {
          return this.data
        }
        const self = this
        let data
        if (this.letter) {
          data = this.data.filter(function (item) {
            return item.capital === self.letter
          })
        }
        if (this.query) {
          const source = data || this.data
          data = source.filter(function (item) {
            return item.name.toLowerCase().includes(self.query)
          })
        }
        return data
      },
      alphabet: function() {
        return Array.from(new Set(this.data.map(function (item) {
          return item.capital
        }))).sort()
      }
    },
    methods: {
      getCapitalLetter(str) {
        const normalized = str.trim().normalize("NFD").replace(/[\u0300-\u036f]/g, "")
        const pattern = /[A-Za-z]/
        const exec = pattern.exec(normalized)
        return exec[0].toUpperCase()
      },
      filterByLetter(letter) {
        this.letter = letter
      },
      filterByQuery(query) {
        this.query = query
      }
    }
  })
})
