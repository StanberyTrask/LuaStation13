require "ui.game.game_ui"
require "sprites.mobs.carbon.human.humans"


steelFloor = {
	[1] = love.graphics.newImage("sprites/tiles/floors/steel/steelfloor.png"), --sprite
	[2] = false, --occlusion
	["hp"] = 256,--hp
	["groundPassible"] = true, --gp
	["airPassible"] = true, --fp
}

steelWall = {
	love.graphics.newImage("sprites/tiles/walls/steel/wall.png"),
	[2] = true, --occlusion
	["hp"] = 256,--hp
	["groundPassible"] = false, --gp
	["airPassible"] = false, --fp
}

Parallax1 = love.graphics.newImage("sprites/effects/parallax/layer1_0.png")
Parallax2 = love.graphics.newImage("sprites/effects/parallax/layer2_0.png")
