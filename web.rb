require 'sinatra'
require 'json'

post '/start/:case' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    # Dummy response
    responseObject = {
        "name" => "battlesnake-ruby",
        "color" => "cyan",
        "head_url" => "http://battlesnake-ruby.herokuapp.com/",
        "taunt" => "battlesnake-ruby"
    }

    return responseObject.to_json
end

post '/move/:case' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    # Dummy response
    responseObject = {
        "move" => "up",
        "taunt" => "going up!"
    }

    return responseObject.to_json
end

post '/end/:case' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    doError(requestJson, params[:case])

    # No response required
    responseObject = {}

    return responseObject.to_json
end


def doError(requestJson, errorCase)
    case errorCase
    when 1

    when 2

    when 3

    when 4

    when 5

    else

    end
end






# Invalid/Incorrect/Missing JSON keys

# Extremely large keys/values

# Non-JSON responses: XML, HTML, Text, Binary

# 2+ second timeouts

# 2+ second response times

post '/'

