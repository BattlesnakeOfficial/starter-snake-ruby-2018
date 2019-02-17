#!/usr/bin/ruby
require 'sinatra'
require 'json'

get '/' do
    'Battlesnake documentation can be found at' \
     '<a href=\"https://docs.battlesnake.io\">https://docs.battlesnake.io</a>.'
end

$board = {x:0, y:0}
$me = []
$health = 0
$id = ""
$food = []
$snakes = [] #this inclues us as well
post '/start' do
    puts "START"
    requestBody = request.body.read
    puts requestBody
    requestJson = requestBody ? JSON.parse(requestBody) : {}
    $board[:x] = requestJson["board"]["width"].to_i
    $board[:y] = requestJson["board"]["height"].to_i
    puts $board.to_s
    $me = requestJson["you"]["body"]
    $health = requestJson["you"]["health"].to_i
    $id = requestJson["you"]["id"]
    puts $me.to_s
    puts $health
    puts $id
    #Response
    responseObject = {
        "color"=> "#000000",
    }
    return responseObject.to_json
end

post '/move' do
    puts "MOVE"
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}
    $me = requestJson["you"]["body"]
    puts "me "+$me.to_s
    $health = requestJson["you"]["health"].to_i
    puts $health
    $food = requestJson["board"]["food"]
    puts "food " + $food.to_s
    $snakes = requestJson["board"]["snakes"]
    puts "snakes " + $snakes.to_s
    directions = ["up", "right", "left", "down"]
    direction = "up"
    #Response
    responseObject = {
        "move" => direction
    }

    return responseObject.to_json
end

post '/end' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    # No response required
    responseObject = {}

    return responseObject.to_json
end

post '/ping' do
  200
end
