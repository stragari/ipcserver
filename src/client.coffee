IPCClient = require('./ipc_manager').client
IPCConfig = require('./config/config').IPC

if process.argv.length < 3
    console.log "Insufficient parameters."
    process.exit 0

argv = process.argv

serverId = console.log argv[2]
clientId = console.log argv[3]

IPCConfig.client.id = clientId

@client = new IPCClient()
@client.setConfig IPCConfig.client
server =
    id: serverId

@client.connect server





