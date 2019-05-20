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

let channelToken = document.getElementsByTagName('meta')[3].content
// debugger;
let sessionUuid = document.getElementById("session_uuid").textContent.trim()
const liveSocket = new LiveSocket("/live", {params: {channel_token: channelToken}})
liveSocket.connect()

liveSocket.socket.onOpen(function(){
  let sessionUuid = document.getElementById("session_uuid").textContent.trim()
  let chatId = window.location.pathname.split("/")[2]
  let channel = liveSocket.channel("event_bus:" + chatId + ":" + sessionUuid, {})
  channel.join().receive("ok", resp => { console.log("JOINED") })

  const targetNode = document.getElementsByClassName("messages")[0]
  channel.on("new_chat_message", function() {
    targetNode.scrollTop = targetNode.scrollHeight
  })

  console.info("the socket was opened")
})


document.addEventListener("DOMContentLoaded", function() {
  const targetNode = document.getElementsByClassName("messages")[0]
  targetNode.scrollTop = targetNode.scrollHeight
});


// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
