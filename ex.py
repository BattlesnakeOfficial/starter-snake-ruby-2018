#Credit: Battlesnake Python
import bottle
import os
import random

grid = []
food_points = []
head = []
closest_food_point = []

U = 0
D = 0
L = 0
R = 0
class Snake:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    def get_x(self):
        return self.x
    def get_y(self):
        return self.y
    def get_health(self):
        return self.health
    def get_id(self):
        return self.id_
    def get_length(self):
        return self.length
    def get_name(self):
        return self.name
    def get_taunt(self):
        return self.taunt
    def isDead(self):
        return self.health == 0
      
class Food:
    def _init_ (self, x, y):
        self.x = x 
        self.y = y
    def get_x(self):
        return self.x
    def get_y(self):
        return self.y
    def get_point(self):
        return (self.x, self.y)

@bottle.route('/static/<path:path>')
def static(path):
    return bottle.static_file(path, root='static/')


@bottle.post('/start')
def start():
    data = bottle.request.json
    game_id = data['game_id']
    board_width = data['width']
    board_height = data['height']

    head_url = '%s://%s/static/head.png' % (
        bottle.request.urlparts.scheme,
        bottle.request.urlparts.netloc
    )

    # TODO: Do things with data
    grid = [([0]*board_width) for row in xrange(board_height)]

    return {
        'color': '#FFD700',
        'taunt': 'hi :)',
        'head_url': 'assets/static/images/snake/head/bendr.svg',
        'name': 'Danger Noodle'
    }

@bottle.post('/move')
def move():
    total = bottle.request.json
    
    #food  
    f = "f"
    for item in total['food']['data']:
        grid[item['x'], item['y']] = f
        food_points.append(item['x'], item['y'])
    food_target()
    
    #put onto grid
    #enemies
    e = "e"
    snake_list = []
    for item_data in total['snakes']['data']['body']['data']:
        snake = Snake(item_data['x'], item_data['y'])
        snake_list.append(snake)
        grid[item_data['x'], item_data['y']] = e
    #me      
    m = "m"
    myHealth = total['you']['health']
    myID = total['you']['id']
    myLength = total['you']['length']
    myName = total['you']['health']
    myTaunt = total['you']['taunt']
    me = Snake(myHealth, myID, myLength, myName, myTaunt)
    for item_data in total['you']['body']['data']:
        head[0] = item_data['x']
        head[1] = item_data['y']
        grid[item_data['x'], item_data['y']] = m
        
    direction = determine()

    if str(direction) == "left":    
        return {
            'move' : 'left'
        }
    elif str(direction) == "right":    
        return {
            'move' : 'right'
        }
    elif str(direction) == "up":    
        return {
            'move' : 'up'
        }
    else:   
        return {
            'move' : 'down'
        }

def isWall(x,y):
    if x>=len(grid) or x<0:
        return True
    elif y>=len(grid) or y<0:
        return True
    else: return False

def isSnake(x,y):
    if not grid[x,y] == 0 and not grid[x,y] == 'f':
        return True

def food_target():
    distance = len(grid)
    for food in food_points:
        temp_dist = (food[0] - head[0])**2 + (food[1] - head[1])**2
        if temp_dist < distance:
            distance = temp_dist
            closest_food_point = [food[0], food[1]]

def check_distance(x,y):
    org_dist = (closest_food_point[0] - head[0])**2 + (closest_food_point - head[1])**2
    new_dist = (closest_food_point[0] - x)**2 + (closest_food_point[1] - y)**2
    if new_dist < org_dist:
        return True
    else:
        return False
  
def determine():
    #Can we go there?
    x = head[0]
    y = head[1]
    if not isWall(x - 1, y) or not isSnake(x-1,y): L = L + 1
    if not isWall(x + 1, y) or not isSnake(x+1,y): R = R + 1
    if not isWall(x, y-1) or not isSnake(x,y-1): D = D + 1
    if not isWall(x, y+1) or not isSnake(x,y+1): U = U + 1
    #check two spots
    if L>0:
        if not isWall(x - 2, y) or not isSnake(x-2,y): L = L + 1
    if R>0:
        if not isWall(x + 2, y) or not isSnake(x+2,y): R = R + 1
    if D>0:
        if not isWall(x, y-2) or not isSnake(x,y-2): D = D + 1
    if U>0:
        if not isWall(x, y+2) or not isSnake(x,y+2): U = U + 1
    #does this get us closer to food?
    if L>0:
        if check_distance(x-1,y): L = L + 1
    if R>0:
        if check_distance(x+1,y): R = R + 1
    if D>0:
        if check_distance(x,y-1): D = D + 1
    if U>0:
        if check_distance(x,y+1): U = U + 1
    result = [[L, "left"], [R, "right"], [D, "down"], [U, "up"]]
    result.sort()
    max = result[0]
    temp = max[1]
    return str(temp)


# Expose WSGI app (so gunicorn can find it)
application = bottle.default_app()
if __name__ == '__main__':
    bottle.run(application, host=os.getenv('IP', '0.0.0.0'), port=os.getenv('PORT', '8080'))
