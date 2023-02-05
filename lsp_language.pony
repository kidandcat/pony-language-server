use "immutable-json"
use "collections"
use "files"
use "backpressure"
use "process"
use "debug"
use "pony-ast/ast"


actor LanguageProtocol
  var initialized: Bool = false
  let channel: Stdio
  let document: DocumentProtocol
  let compiler: PonyCompiler


  new create(compiler': PonyCompiler, channel': Stdio, document': DocumentProtocol) =>
    compiler = compiler'
    channel = channel'
    document = document'


  be handle_hover(msg: RequestMessage val) =>
    match msg.params
    | let p: JsonObject => 
      try
        let text_document = p.data("textDocument")? as JsonObject
        let uri = text_document.data("uri")? as String
        let position = p.data("position")? as JsonObject
        let line = position.data("line")? as I64
        let character = position.data("character")? as I64
        let filepath = uri.clone()
        filepath.replace("file://", "")
        let notifier = HoverNotifier(msg.id, compiler, channel)
        compiler.get_type_at(filepath.clone(), line.usize()+1, character.usize()+1, notifier)
      else
        Log(channel, "ERROR retrieving textDocument uri: " + msg.json().string())
        channel.send_message(ResponseMessage(msg.id, None, ResponseError(-32700, "parse error")))
      end
    else
      channel.send_message(ResponseMessage(msg.id, None, ResponseError(-32700, "parse error")))
    end


actor HoverNotifier
  let id: (I64 val | String val | None val)
  let compiler: PonyCompiler
  let channel: Stdio

  new create(
      id': (I64 val | String val | None val),
      compiler': PonyCompiler, 
      channel': Stdio
    ) =>
    id = id'
    compiler = compiler'
    channel = channel'

  be type_notified(t: (String | None)) => 
    match t
    | let s: String => 
      Log(channel, "type_notified " + s)
      channel.send_message(ResponseMessage(id, JsonObject(
        recover val
          Map[String, JsonType](1)
            .>update("contents", JsonObject(
              recover val
                Map[String, JsonType](2)
                  .>update("kind", "markdown")
                  .>update("value", s)
              end
            ))
        end
      )))
    | None => 
      Log(channel, "type_notified is None")
      channel.send_message(ResponseMessage(id, JsonObject(
        recover val
          Map[String, JsonType](1)
            .>update("contents", JsonObject(
              recover val
                Map[String, JsonType](2)
                  .>update("kind", "markdown")
                  .>update("value", "❌")
              end
            ))
        end
      )))
    end