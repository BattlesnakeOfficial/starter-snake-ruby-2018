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
    puts "Closest Food Coordinates: (", $food[findClosestFood()]["x"], ",", $food[findClosestFood()]["y"], ")"
    

    #Response
    #If health<closestFoodLen then move => lookforfood else circleBoard
    responseObject = {
        "move" => moveToClosestFood()
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

def findClosestFood()
    i = 0
    min = 1000
    minIndex = 0

    loop do
        if i == $food.length
            break
        end

        deltaX = ($food[i]["x"] - $head["x"]).abs
        deltaY = ($food[i]["y"] - $head["y"]).abs
        lenSquared = (deltaX*deltaX) + (deltaY*deltaY) #Length squared bc of lack of sqrt function
        len = Math.sqrt(lenSquared)

        if len < min
            min = len
            minIndex = i
        end
        i = i + 1
    end

    return minIndex
end

def moveToClosestFood()
    dY = $head["y"] - $food[findClosestFood()]["y"]
    dX = $head["x"] - $food[findClosestFood()]["x"]

    if (dY > 0)
        dirY = "up"
        altY = "down"
    else
        dirY = "down"
        altY = "up"
    end

    if (dX > 0)
        dirX = "left"
        altX ="right"
    else
        dirX = "right"
        altX ="left"
    end

    if (dirX > dirY)
        if (dirX == dirToDie())
            return altX
        else
            return dirX
        end
    else
        if (dirY = dirToDie())
            return altY
        else
            return dirY
        end
    end
end

def dirToRunIntoSelf()
    headX = $me[0]["x"]
    headY = $me[0]["y"]
    bodyX = $me[1]["x"]
    bodyY = $me[1]["y"]
    dX = headX - bodyX
    dY = headY - bodyY

    if (dX == 0)
        #The body part is under or above the head
        if (dY > 0)
            dir = "up"
        else
            dir = "down"
        end
    else
        if (dX > 0)
            dir = "left"
        else
            dir = "right"
        end
    end
    return dir
end