trait Message
    fun jsonrpc(): String => "2.0"


class RequestMessage is Message
    var id: (LSPInteger | String)
    var method: String
    var params: (None | LSPArray | LSPObject)
    new ref create(id': (LSPInteger | String), method': String, params': (None | LSPArray | LSPObject)) =>
        id = id'
        method = method'
        params = params'


class ResponseMessage is Message
    var id: (None | LSPInteger | String)
    var result: (None | String | LSPNumber | Bool | LSPObject)
    var response_error: (None | ResponseError)
    new ref create(
        id': (None | LSPInteger | String), 
        result': (None | String | LSPNumber | Bool | LSPObject), 
        response_error': (None | ResponseError)
    ) =>
        id = id'
        result = result'
        response_error = response_error'


class ResponseError
    var code: LSPInteger
    var message: String
    var data: (None | String | LSPNumber | Bool | LSPArray | LSPObject)
    new ref create(code': LSPInteger, message': String, data': (None | String | LSPNumber | Bool | LSPArray | LSPObject)) =>
        code = code'
        message = message'
        data = data'


primitive ErrorCodes
    fun parseError(): LSPInteger => -32700
    fun invalidRequest(): LSPInteger => -32600
    fun methodNotFound(): LSPInteger => -32601
    fun invalidParams(): LSPInteger => -32602
    fun internalError(): LSPInteger => -32603
    fun jsonrpcReservedErrorRangeStart(): LSPInteger => -32099
    fun serverErrorStart(): LSPInteger => -32099
    fun serverNotInitialized(): LSPInteger => -32002
    fun unknownErrorCode(): LSPInteger => -32001
    fun jsonrpcReservedErrorRangeEnd(): LSPInteger => -32000
    fun serverErrorEnd(): LSPInteger => -32000
    fun lspReservedErrorRangeStart(): LSPInteger => -32899
    fun requestFailed(): LSPInteger => -32803
    fun serverCancelled(): LSPInteger => -32802
    fun contentModified(): LSPInteger => -32801
    fun requestCancelled(): LSPInteger => -32800
    fun lspReservedErrorRangeEnd(): LSPInteger => -32800


class NotificationMessage is Message
    var method: String
    var params: (None | LSPArray | LSPObject)
    new ref create(method': String, params': (None | LSPArray | LSPObject)) =>
        method = method'
        params = params'


// method: ‘$/cancelRequest’
class CancelParams
    var id: (LSPInteger | String)
    new ref create(id': (LSPInteger | String)) =>
        id = id'


// method: ‘$/progress’
class ProgressParams
    var token: ProgressToken
    var value: String
    new ref create(token': ProgressToken, value': String) =>
        token = token'
        value = value'


class HoverParams
    var textDocument: String
    var position: Position
    new ref create(textDocument': String, position': Position) =>
        textDocument = textDocument'
        position = position'


class HoverResult
    var value: String
    new ref create(value': String) =>
        value = value'