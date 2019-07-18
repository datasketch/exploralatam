window.addEventListener('DOMContentLoaded', setBodyMargin)
window.addEventListener('resize', setBodyMargin)

function setBodyMargin () {
  const header = document.querySelector('header')
  const main = document.querySelector('main')
  const boundary = header.offsetHeight
  main.style.marginTop = boundary + 'px'
}