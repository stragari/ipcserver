IPCServer = require('./ipc_manager').server
IPCConfig = require('./config/config').IPC

class Server

    constructor: ->
        @subscribers = []
        @server = new IPCServer()

        @init()

    init: ->
        @server.setConfig IPCConfig.server
        @server.create()
        .then =>
            console.log "[Server]: Server was started successfully"

            @server.emit IPCConfig.channels.HELLO_EVENTS, 'hello'

            console.log "[Server]: Emitted 'hello' by 'hello' channel"

            console.log "[Server]: set 'on'"

#            @server.on IPCConfig.channels.HELLO_EVENTS, @hello
#            @server.on IPCConfig.channels.BY_EVENTS, @by
#            @server.on IPCConfig.channels.EVENTS, @event
#            @server.on 'connected', @clientConnected
#            @server.on 'disconnected', @clientDisconnected

            console.log "[Server]: set 'on' done"

        .fail (error) ->
            console.error "[Server] - [init]: #{error}"

    hello: (data) ->
        console.log "[Server] - [_hello]: received event '_clientConnected' "
        console.log data

    clientConnected: (data) ->
        console.log "[Server] - [_clientConnected]: received event '_clientConnected' "
        console.log data

    clientDisconnected: (data) ->
        console.log "[Server] - [_clientDisconnected]: received event '_clientDisconnected' "
        console.log data

    by: (data) ->
        console.log "[Server] - [by]: received event 'by' "

    event: (data) ->
        console.log "[Server] - [event]: received event 'event' make something "

module.exports = Server


server = new Server()