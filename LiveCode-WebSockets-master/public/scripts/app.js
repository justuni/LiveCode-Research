// establish a websocket connection to our wss

// listen for "sendButton" click events to send messages to wss

// display broadcasted messages from wss

(function(window) {
  const sendButton = document.getElementById('sendButton');
  const messageLog = document.getElementById('messageLog');
  const username = document.getElementById('username');
  const message = document.getElementById('message');

  // Create WebSocket connection.
  const socket = new WebSocket('ws://10.0.1.9:3000');

  sendButton.addEventListener('click', e => {
    socket.send(
      JSON.stringify({
        OP: 'CHAT',
        message: message.value,
        username: username.value
      })
    );
  });

  function appendToLog(username, message) {
    const newMessage = document.createElement('li');
    newMessage.innerText = `${username} : ${message}`;
    messageLog.appendChild(newMessage);
  }

  // Connection opened
  socket.addEventListener('open', function(event) {
    socket.send(
      JSON.stringify({
        OP: 'CONNECTED'
      })
    );
    appendToLog('Connected to chat server');
  });

  // Listen for messages
  socket.addEventListener('message', function(event) {
    const payload = JSON.parse(event.data);
    switch (payload.OP) {
      case 'DEATH':
        gameOver();
        break;
      case 'MOVE_RIGHT':
        moveUser(payload.user, payload.distance);
        break;
      case 'CHAT':
        appendToLog(payload.username, payload.message);
        break;
      case 'SUCCESSFUL_CONNECTION':
        break;
      default:
        console.error(`received unsupported OP: ${payload}`);
    }
  });
})(window);
