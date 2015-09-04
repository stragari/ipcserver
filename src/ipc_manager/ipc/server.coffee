Q = require 'q'

###
Creates and handles IPC Servers.
###
class Server

    ###
    Constructs an instance of IPC server.
    ###
    constructor: ->
        @ipc = require 'node-ipc'

    ###
    Creates an ipc server.
    @param config [Object] custom configuration for server
    @return [Promise] if it is resolved nothing otherwise an error
    ###
    create: ->
        deferred = Q.defer()
        try
            @ipc.serveNet ->
                deferred.resolve()
            _onSubscribe.call @
            _onUnsubscribe.call @
            @ipc.server.start()
        catch error
            deferred.reject error
        deferred.promise

    ###
    Sets the configuration of IPC server.
    @param config [Object] custom configuration for server
    @example config object
      appspace: 'app.'
      socketRoot: '/tmp/'
      id: os.hostname()  or name of channel
      networkHost: 'localhost'
      networkPort: 8000
      encoding: 'utf8'
      silent: false
      maxConnections: 100
      retry: 500
      maxRetries: false
      stopRetrying: false
    ###
    setConfig: (config) ->
        try
            for field, value of config
                @ipc.config[field] = value

        catch error
            console.error "[IPC_SERVER] - [setConfig]: #{error}"

    ###
    Emits data to all subscribed sockets.
    @param type [String] message type or channel name
    @param data [Object, String, Number] data to send via sockets
    ###
    emit: (type, data) ->
        @ipc.server.broadcast type, data

    ###
    Subscribes to IPC server to listen a specific socket.
    @param type [String] message type or channel name
    @param callback [Function] it is called when data was sent.
    ###
    on: (type, callback) ->
        @ipc.server.on type, callback

    ###
    Listens subscribe events from servers.
    @private
    ###
    _onSubscribe = ->
        @ipc.server.on 'subscribe', (data, socket) =>
            sockets = @ipc.server.sockets
            sockets.push socket if sockets.indexOf(socket) < 0

    ###
    Listens unsubscribe events from servers.
    @private
    ###
    _onUnsubscribe = ->
        @ipc.server.on 'unsubscribe', (data, socket) =>
            socketIndex = @ipc.server.sockets.indexOf socket
            #id = @ipc.config['id']
            #@ipc.server.sockets[socketIndex].disconnect id
            @ipc.server.sockets.splice socketIndex, 1 if socketIndex >= 0

module.exports = Server
