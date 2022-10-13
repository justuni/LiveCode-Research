const express = require('express');
const http = require('http');
const url = require('url');
const WebSocket = require('ws');
const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.static('./public'));

const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

const users = [];

wss.on('connection', function connection(ws, req) {
  // const location = url.parse(req.url, true);

  users.push(ws);

  ws.on('message', function incoming(message) {
    const payload = JSON.parse(message);
    // console.log('received: %s', payload);

    switch (payload.OP) {
      case 'CREATE_ROOM':
        rooms.createRoom(payload.roomName);
        ws.send(
          JSON.stringify({
            OP: 'CREATE_ROOM_SUCCESS'
          })
        );
        break;
      case 'CHAT': // broadcast
        users.forEach(user => {
          user.send(
            JSON.stringify({
              OP: 'CHAT',
              message: payload.message,
              username: payload.username
            })
          );
        });
        break;
      case 'CONNECTED':
        console.log('a user has connected');
        break;
    }
  });

  ws.send(
    JSON.stringify({
      OP: 'SUCCESSFUL_CONNECTION'
    })
  );
});

server.listen(PORT, function listening() {
  console.log('Listening on %d', server.address().port);
});
