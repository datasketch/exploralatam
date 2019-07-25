const DOMUtils = function DOMUtils() { }

DOMUtils.createElement = function createElement(tag, opts) {
  return {
    tag: tag,
    attrs: opts.attrs || {},
    children: opts.children || [],
  }
}

DOMUtils.renderElement = function renderElement(node) {
  const element = document.createElement(node.tag)

  for (const [attr, value] of Object.entries(node.attrs)) {
    element.setAttribute(attr, value)
  }

  for (const child of node.children) {
    element.appendChild(DOMUtils.render(child))
  }

  return element
}

DOMUtils.render = function render(node) {
  if (typeof node === 'string') {
    return document.createTextNode(node)
  }
  return DOMUtils.renderElement(node)
}