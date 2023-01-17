use "immutable-json"
use "collections"


actor LifecycleProtocol
  var initialized: Bool = false
  var channel: Stdio
  var debug: Debugger


  new create(channel': Stdio, debug': Debugger) =>
    channel = channel'
    debug = debug'


  be handle_initialize(msg: RequestMessage val) =>
    if initialized then
      debug.print("Server already initialized")
      channel.send_message(ResponseMessage(msg.id, "", ResponseError(
        -32002,
        "Server already initialized"
      )))
    end
    channel.send_message(ResponseMessage(msg.id, JsonObject(
      recover val
        Map[String, JsonType](2)
          .>update("capabilities", JsonObject(
            recover val
              Map[String, JsonType](2)
                .>update("hoverProvider", true)
                // Full sync seems to be needed to receive textDocument/didSave
                .>update("textDocumentSync", I64(2))
                // We are using publish diagnostics, owned by the server
                // this capability provides pull diagnostics, owned by the client
                // .>update("diagnosticProvider", JsonObject(
                //   recover val
                //     Map[String, JsonType](2)
                //       .>update("interFileDependencies", true)
                //       .>update("workspaceDiagnostics", false)
                //   end
                // ))
            end
          ))
          .>update("serverInfo", JsonObject(
            recover val
              Map[String, JsonType](2)
                .>update("name", "Pony LS")
                .>update("version", "0.0.1")
            end
          ))
      end
    )))
    

  be handle_initialized(msg: RequestMessage val) =>
    None