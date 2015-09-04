ipc = require 'node-ipc'
net = require 'net'


dateInit = null

translateMilisecondTStandarHour = (diff) ->
    hour =
        hours: Math.floor(diff / (1000 * 60 * 60))
        mins: Math.floor(diff / (1000 * 60))
        secs: Math.floor(diff / 1000)

    return hour

serverMessage = (data, socket) =>
    # proccess data
    if dateInit is null
        dateInit = new Date()

    data =
        id: ipc.config.id
        typeEvent: 'done'
        message : data.message

    ipc.server.emit socket, 'done', data

disconnect = (data, socket) =>
    console.log '[disconnect - channel]'

shutdown = (data, socket) =>
    console.log '[shutdown - channel]'
    ipc.server.emit socket, 'disconnected', data

    dateEnd = new Date()
    dateMillisecond = dateEnd.getTime() - dateInit.getTime()
    hour = translateMilisecondTStandarHour dateMillisecond
    console.log 'total: ', hour
    console.log 'dateMillisecond: ', dateMillisecond

connect  = (socket) =>
    console.log '[connect - channel]'
    ipc.server.emit socket, 'event', hello: 'world'

listen = () ->
    ipc.server.on 'channel-ipc', serverMessage
    ipc.server.on 'disconnect', disconnect
    ipc.server.on 'shutdown', shutdown
    ipc.server.on 'connect', connect

ipc.config.id   = 'exampleServer'
ipc.config.retry = 1500
ipc.config.silent = true

ipc.serve listen

ipc.server.define.listen['channel-ipc'] = 'This event type listens for command arguments.'
ipc.server.define.listen['disconnect'] = 'This event type listens for command arguments.'
ipc.server.define.listen['shutdown'] = 'This event type listens for command arguments.'
ipc.server.define.listen['done'] = 'This event type listens for command arguments.'
ipc.server.define.listen['event'] = 'This event type listens for command arguments.'

ipc.server.start()
