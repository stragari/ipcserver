
if process.argv.length < 3
    console.log "Insufficient parameters."
    process.exit 0

argv = process.argv
serverId = argv[2]
clientId = argv[3]
numberReq = 0
countDone = 0

limitCicle = 1000000

translateMilisecondTStandarHour = (diff) ->
    hour =
        hours: Math.floor(diff / (1000 * 60 * 60))
        mins: Math.floor(diff / (1000 * 60))
        secs: Math.floor(diff / 1000)

    return hour


ipc = require 'node-ipc'
ipc.config.id   = 'exampleServer'
ipc.config.retry = 1000
ipc.config.silent = true


ipc.connectTo serverId, ->
    ipc.of[serverId].on 'connect', ->

        dateInit = new Date()

        dataSent =
            id : ipc.config.id
            message : argv

        for [0...limitCicle]
            numberReq++

            dataSent['requ'] = numberReq
            ipc.of[serverId].emit 'channel-ipc', dataSent

        ipc.of[serverId].on 'channel-ipc', (data) ->
            console.log data

        ipc.of[serverId].on 'event', (data) ->
            console.log '[onEvent] - ', data

        ipc.of[serverId].on 'disconnected', (data) ->
            ipc.of[serverId].emit 'disconnect'

            dateEnd = new Date()
            dateMillisecond = dateEnd.getTime() - dateInit.getTime()
            hour = translateMilisecondTStandarHour dateMillisecond
            console.log 'total: ', hour
            console.log 'dateMillisecond: ', dateMillisecond
            process.exit 0

        ipc.of[serverId].on 'done', (socket) ->
            countDone++
            # [onDone] - countDone
            if countDone is limitCicle
                ipc.of[serverId].emit 'shutdown', socket.id, {id: clientId, data: ':P'}
                console.log '[onConnect] - Emitted "shutdown" '
