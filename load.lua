local utf8 = require "utf8"
require "functions"
require "maps.mapconvert"
require "sprites.mobs.carbon.human.humans"

steelFloor = {
	[1] = love.graphics.newImage("sprites/tiles/floors/steel/steelfloor.png"), --sprite
	[2] = false, --does this tile occlude
	["hp"] = 256,--hp
	["groundPassible"] = true, --gp
	["airPassible"] = true, --fp
}

steelWall = {
	[1] = love.graphics.newImage("sprites/tiles/walls/steel/wall.png"), --sprite
	[2] = true, --does this tile occlude
	["hp"] = 256,--hp
	["groundPassible"] = false, --gp
	["airPassible"] = false, --fp
}

pockets = love.graphics.newImage("sprites/UI/pockets.png")
Parallax1 = love.graphics.newImage("sprites/effects/parallax/layer1_0.png")
Parallax2 = love.graphics.newImage("sprites/effects/parallax/layer2_0.png")
