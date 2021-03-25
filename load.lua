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

-- make wires drawable,
--MSB layer
--b4 left
--b3 right
--
--
ec00000 = love.graphics.newImage("sprites/objects/electric_cable/l1-noconnection_0.png")
--[[ec00001 = love.graphics.newImage("")
ec00010 = love.graphics.newImage("")
ec00011 = love.graphics.newImage("")
ec00100 = love.graphics.newImage("")
ec00101 = love.graphics.newImage("")
ec00110 = love.graphics.newImage("")
ec00111 = love.graphics.newImage("")
ec01000 = love.graphics.newImage("")
ec01001 = love.graphics.newImage("")
ec01010 = love.graphics.newImage("")
ec01011 = love.graphics.newImage("")
ec01100 = love.graphics.newImage("")
ec01101 = love.graphics.newImage("")
ec01110 = love.graphics.newImage("")
ec01111 = love.graphics.newImage("")]]
