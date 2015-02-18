require 'sinatra'
require 'json'

post '/:case/start' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    return doError('start', requestJson, params[:case])
end

post '/:case/move' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    return doError('move', requestJson, params[:case])
end

post '/:case/end' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    return doError('end', requestJson, params[:case])
end


def doError(action, requestJson, errorCase)
    errorCase = Integer(errorCase)
    case errorCase
    when 0  # Nothing
        return

    when 1  # Bad JSON keys
        return {
            "bad_key" => "value",
            "another_bad_key" => "another value"
        }.to_json

    when 2  # Bad JSON values
        case action
        when 'start'
            return {
                "name" => nil,
                "color" => "not-a-colour",
                "head_url" => "not-a-url",
                "taunt" => 12345
            }.to_json
        when 'move'
            return {
                "move" => {},
                "taunt" => {"cat" => "meow"}
            }.to_json
        end

    when 3  # Text response
        return "I am text"

    when 3  # XML response
        return "<html><head></head><body>I'm HTML!</body></html>"

    when 4  # Binary response
        content_type 'application/octet-stream'
        return "\x01\x02\x03"

    when 5  # 4xx response
        status 400

    when 6  # 5xx response
        status 500

    when 7  # 2 second response timeout
        sleep(2.5)

    when 8  # 2 second response exceed
        stream do |out|
            out.puts "Here's some text"
            out.write "Here's some more text"
            out.putc(65) unless out.closed?  # not sure
            sleep(2.5)
            out.puts "Here's some text"
            out.write "Here's some more text"
            out.flush
        end

    when 9  # Nil
        return nil

    else
        return "Unknown error case"

    end
end
