require 'sinatra'
require 'json'

class Coords
  def intialize(json)
    @x = JSON.parse(json)['x']
    @y = JSON.parse(json)['y']
  end
end

class Snake
  def intialize(json)
    @id = JSON.parse(json)['id']
    @name = JSON.parse(json)['name']
    @health = JSON.parse(json)['health']

    if JSON.parse(json)['body'].instance_of ? List:
      @body = Coords(JSON.parse(json)['body'][0])
    end

  end

  def head
    if self.send(:body)
      return self.body[0]
    end
  end
end