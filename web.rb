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
$snakes = [] #this includes us as well
$head = []
$directions = {"up"=>[], "down"=>[], "left"=>[], "right"=>[]} #each possible direction with array of coordinates
post '/start' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}
    $board[:x] = requestJson["board"]["width"].to_i
    $board[:y] = requestJson["board"]["height"].to_i
    $me = requestJson["you"]["body"]
    $health = requestJson["you"]["health"].to_i
    $id = requestJson["you"]["id"]
    $head = $me[0]

    #Response
    responseObject = {
    "color"=> "#000000",
    }
    return responseObject.to_json
end

post '/move' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}
    $me = requestJson["you"]["body"]
    $health = requestJson["you"]["health"].to_i
    $food = requestJson["board"]["food"]
    $snakes = requestJson["board"]["snakes"]
    $head = $me[0]
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

#takes direction (up, down, left, right)
#returns true if position next to head is out of bounds
#returns false if position is not out of bounds
def isOutOfBounds(direction)

  x=0
  y=0

  case direction
  when "up"
    x=$head["x"]
    y=$head["y"] - 1
  when "down"
    x=$head["x"]
    y=$head["y"] + 1
  when "left"
    x=$head["x"] - 1
    y=$head["y"]
  when "right"
    x=$head["x"] + 1
    y=$head["y"]
  end

  if x<0 or x>14 or y<0 or y>14
    return true
  else
    return false
  end

end

#circles the board lol
def circleBoard()

    direction = ""

    #at upper wall (but not corner)
    if $head["y"] == 0
        direction = "left"
    end

    #at lower wall (but not corner)
    if  $head["y"] == $board[:y] - 1
        direction = "right"
    end  

    #at left wall (but not corner)
    if $head["x"] == 0
        direction = "down"
    end

    #at right wall (but not corner)
    if $head["x"] == $board[:x] - 1
        direction = "up"
    end

    #at top left corner
    if $head["x"] == 0 and $head[:x] == 0
      direction="down"
    end

    #at top right corner
    if $head["x"] == $board[:x] - 1 and $head["y"] == 0
      direction="left"
    end

    #at bottom left corner
    if $head["x"] == 0 and $head["y"] == $board[:y] - 1
      direction="right"
    end

    #at bottom right corner
    if $head["x"] == $board[:x] - 1 and $head["y"] == $board[:y] - 1
      direction="up"
    end
  
    return direction
    

end



