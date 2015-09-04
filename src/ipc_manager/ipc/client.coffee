# Loading third party libraries
Q = require 'q'

###
Creates and handles IPC clients.
###
class Client

    ###
    Constructs an instance of IPC client.
    ###
    constructor: ->
        @ipc = require 'node-ipc'

    ###
    Sets the configuration of IPC client.
    @param config [Object] custom configuration for IPC client
    @example config object
      appspace: 'app.'
      socketRoot: '/tmp/'
      id: os.hostname()
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
            console.error "[IPC_CLIENT] - [setConfig]: #{error}"

    ###
    Connects client with a specific server
    @param serverData [Object] server specifications
    @example server data
      id: 'TMServer'
    @return [Promise] if it is resolved the client instance otherwise an error
    ###
    connect: (server) ->
        deferred = Q.defer()
        @serverId = server.id

        console.error "[IPC_CLIENT] - [connect]: try connect"

        try
            @ipc.connectToNet @serverId, =>

                console.error "[IPC_CLIENT] - [connected]"
                @emit 'connected', {id : @ipc.config.id}

                deferred.resolve @ipc.of[@serverId]
        catch error
            console.error "[IPC_CLIENT] - [connect]: Error: #{error}"
            deferred.reject error

        deferred.promise

    ###
    ###
    disconnect: ->
        @ipc.disconnect @serverId

    ###
    Emits data to IPC server.
    @param type [String] message type or channel name
    @param data [Object, String, Number] data to send via sockets
    ###
    emit: (type, data) ->
        @ipc.of[@serverId].emit type, data

    ###
    Subscribes to IPC client to listen a specific server event.
    @param type [String] message type or channel name
    @param callback [Function] it is called when data was sent.
    ###
    on: (type, callback) ->
        @ipc.of[@serverId].on type, callback

module.exports = Client
