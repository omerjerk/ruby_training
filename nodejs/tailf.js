#!/usr/bin/env node

var fs = require("fs");
var net = require("net");
var WebSocketServer = require('websocket').server;
var http = require('http');

var server = http.createServer(function(request, response) {
    console.log((new Date()) + ' Received request for ' + request.url);
    response.writeHead(404);
    response.end();
});
server.listen(8080, function() {
    console.log((new Date()) + ' Server is listening on port 8080');
});

wsServer = new WebSocketServer({
    httpServer: server,
    autoAcceptConnections: false
});

wsServer.on('request', function(request) {
    var connection = request.accept('', request.origin);
    console.log((new Date()) + ' Connection accepted.');

    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            console.log('Received Message: ' + message.utf8Data);
            // connection.sendUTF(message.utf8Data);
        }
        else if (message.type === 'binary') {
            console.log('Received Binary Message of ' + message.binaryData.length + ' bytes');
            connection.sendBytes(message.binaryData);
        }
        fs.open("logfile.txt", "a+", function(err, fd) {
            fs.watchFile("logfile.txt", {interval:500}, function(curr, prev) {
                var change = curr.size - prev.size;
                console.log("change = " + change);
                if (change != 0) {
                    var derp = readFile(fd, prev.size, change);
                    console.log("read = "+ derp);
                    connection.sendUTF(derp + "\n");
                }
                // connection.sendUTF("change = " + change;
            });    
        });
        
    });
    connection.on('close', function(reasonCode, description) {
        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');
    });
});

function readFile(fd, offset, length) {
    var chunkSize = 8;
    var buffer = new Buffer(length);
    var bytesRead = 0;
    while (bytesRead < length) {
        if ((bytesRead + chunkSize) > length) {
            chunkSize = length - bytesRead;
        }
        fs.readSync(fd, buffer, bytesRead, chunkSize, offset + bytesRead);
        bytesRead += chunkSize;
    }
    return buffer.toString();
}
