// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live")
liveSocket.connect()

// Select the node that will be observed for mutations
const targetNode = document.getElementsByClassName("messages")[0]

document.addEventListener("DOMContentLoaded", function() {
  targetNode.scrollTop = targetNode.scrollHeight
});
// Options for the observer (which mutations to observe)
let config = { attributes: true, childList: true, subtree: true };
// Callback function to execute when mutations are observed
var callback = function(mutationsList, observer) {
  for(var mutation of mutationsList) {
    if (mutation.type == 'childList') {
      targetNode.scrollTop = targetNode.scrollHeight
    }
  }
};
// Create an observer instance linked to the callback function
var observer = new MutationObserver(callback);
// Start observing the target node for configured mutations
observer.observe(targetNode, config);

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
