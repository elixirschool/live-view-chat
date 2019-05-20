# important to note that channel and LV must share a socket so that pub/sub message passing is blocking. Otherwise have race conditions. So, I took the LV socket code from source, copied it in and extended it with 1) a "chat channel", subscribing to an "event_bus:#{chat_id}" topic to which LV can publish messages for channel to act on, 2) some connection logic so we can connect with token and grab user ID. This is b/c channel will need awareness of the current user in order to act on LV messages from the correct session.

1. LV mounts, stores user ID in state, renders
2. LV socket connects, (auths current user with token) stores current user ID in state
3. Channel joins on THIS socket

Later...
1. User fills out chat form and submits -> event to LV.
2. LV receives events, updates state and re-renders
3. LV broadcasts event to all other subscribing LV on "LV" topic.
4. All LVs receive event, including self,
   * Send message to self to broadcast on the Event Bus topic. Send to self so that we can re-render and _then_ act on receipt of this message
   * update and re-render if needed (i.e. LV that send the event to itself will not re-render again)
5. Receive/act on "send to event bus" message. Broadcast a message to the "EB" topic--i.e. the topic of the channel.
6. Channels receive event and check to see if the message was broadcasted from "their" LV, i.e. the LV for the same user/session (Event broadcasted with user ID from LV socket state, Channel checks the user ID in its socket state). If match, push it to the subscribing client, otherwise do nothing.
7. JS client receives event, does a little JS.
