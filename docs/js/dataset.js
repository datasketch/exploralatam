const Dataset = function () { }

Dataset.prototype.deleteMissing = function deleteMissing(key) {
  this.data = this.data.filter(function (item) {
    return item[key]
  })
}

Dataset.prototype.get = function get() {
  return this.data
}

Dataset.prototype.set = function set(data) {
  this.data = data
}
