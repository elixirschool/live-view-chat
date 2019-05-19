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

let userId = document.getElementById("user_id").innerText
let liveSocket = new LiveSocket("/live", {params: {user_id: userId}})
liveSocket.connect()

let chatId = window.location.pathname.split("/")[2]

let channel = liveSocket.channel("event_bus:" + chatId, {})
channel.join().receive("ok", resp => { console.log("JOINED") })

const targetNode = document.getElementsByClassName("messages")[0]
channel.on("new_chat_message", function() {
  console.log("HI")
  targetNode.scrollTop = targetNode.scrollHeight
  document.getElementById("members").append("<h1>HI</h1>")
})

document.addEventListener("DOMContentLoaded", function() {
  const targetNode = document.getElementsByClassName("messages")[0]
  targetNode.scrollTop = targetNode.scrollHeight
});


// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
