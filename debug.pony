use "files"
use "immutable-json"
use "collections"


actor Debugger
  var channel: (Stdio | None) = None
  var pending_logs: Array[String] = Array[String]

  be connect_channel(channel': Stdio) =>
    channel = channel'

  be print(data: String) => None
    // pending_logs.push(data)
    // match channel
    // | let c: Stdio => 
    //     for m in pending_logs.values() do
    //       c.send_message(RequestMessage(None, "$/logTrace", JsonObject(
    //         recover val
    //           Map[String, JsonType](1)
    //             .>update("message", m)
    //         end
    //       )))
    //     end
    //     pending_logs.clear()
    // end