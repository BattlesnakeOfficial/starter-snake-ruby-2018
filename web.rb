#!/usr/bin/ruby
require 'sinatra'
require 'json'

get '/' do
    'Battlesnake documentation can be found at' \
     '<a href=\"https://docs.battlesnake.io\">https://docs.battlesnake.io</a>.'
end

$board = {x:0, y:0}
$me = {x:0,y:0}
$health = 0
$id = ""
$food = []
# $enemies = []
post '/start' do
    puts "START"
    requestBody = request.body.read
    puts requestBody
    requestJson = requestBody ? JSON.parse(requestBody) : {}
    $board[:x] = requestJson["board"]["width"].to_i
    $board[:y] = requestJson["board"]["height"].to_i
    puts $board.to_s
    $me[:x] = requestJson["you"]["body"][0]["x"].to_i
    $me[:y] = requestJson["you"]["body"][0]["y"].to_i
    $health = requestJson["you"]["health"].to_i
    $id = requestJson["you"]["id"]
    puts $me.to_s
    puts $health
    puts $id
    
    #Response
    responseObject = {
    "color"=> "#a7d366",
    }
    return responseObject.to_json
end

post '/move' do
    puts "MOVE"
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}
    $me[:x] = requestJson["you"]["body"][0]["x"].to_i
    $me[:y] = requestJson["you"]["body"][0]["y"].to_i
    puts $me.to_s
    $health = requestJson["you"]["health"].to_i
    puts $health
    puts $board.to_s
    $food = requestJson["board"]["food"]
    puts $food.to_s
    directions = ["up", "right", "left", "down"]
    direction = "up"

    #at upper wall (but not corner)
    if $me[:y] == 0
        direction = "left"
    end

    #at lower wall (but not corner)
    if  $me[:y] == $board[:y] -1
        direction = "right"
    end  

    #at left wall (but not corner)
    if $me[:x] == 0
        direction = "down"
    end

    #at right wall (but not corner)
    if $me[:x] == $board[:x] -1
        direction = "up"
    end

    #at top left corner
    if $me[:x] == 0 and $me[:y] ==0
      direction="down"
    end

    #at top right corner
    if $me[:x] == $board[:x] - 1 and $me[:y] == 0
      direction="left"
    end

    #at bottom left corner
    if $me[:x] == 0 and $me[:y] == $board[:y] - 1
      puts "AHHHHHH"
      direction="right"
    end

    #at bottom right corner
    if $me[:x] == $board[:x] - 1 and $me[:y] == $board[:y] - 1
      direction="up"
    end

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
