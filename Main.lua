require "load"
require "maps.luabase"
require "maps.mapconvert"
local utf8 = require "utf8"

function love.load()
	playerSpeed = 20 --multipier of the player speed
	courier = love.graphics.newFont("09809_COURIER.ttf", 20)
	px, py = 120, 120 --current player coordinates
	gx, gy = 19, 15 --the number of grids the player can see
	dx, dy = (gx*32) + 300, gy*32 --disply size in pixels
	love.window.setMode(dx, dy, {resizable = false}) --sets window scale
	isTyping = false
	chatHistory, mesageNumber, playerText = {}, 0, ""
	test = false
end

function round(number)
  if (number - (number % 0.1)) - (number - (number % 1)) < 0.5 then
    number = number - (number % 1)
  else
    number = (number - (number % 1)) + 1
  end
 return number
end

function love.keypressed(key)
	if key == "return" then
		isTyping = not isTyping
	end

	if isTyping == true then
		if key == "backspace" then
			-- get the byte offset to the last UTF-8 character in the string.
			local byteoffset = utf8.offset(playerText, -1)

			if byteoffset then
				-- remove the last UTF-8 character.
				-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
				playerText = string.sub(playerText, 1, byteoffset - 1)
			end
		end
	end
end

function love.textinput(text)
	if isTyping == true then
		love.keyboard.setKeyRepeat(true)
		playerText = playerText..text
		chatHistory[mesageNumber] = playerText
	elseif isTyping == false then
		love.keyboard.setKeyRepeat(false)
	end
end

function love.keyreleased(key)
	if key == "return" and isTyping == true then
		mesageNumber = mesageNumber + 1
	end
end

function love.update(dt)
	if isTyping == false then
		if love.keyboard.isDown("w") and py > 1 and mapData[round(px).."."..(round(py)-1)]["groundPassible"] == true then
			py = py - 1 * dt * playerSpeed
		end

		if love.keyboard.isDown("s") and py < 254 and mapData[round(px).."."..(round(py)+1)]["groundPassible"] == true then
			py = py + 1 * dt * playerSpeed
		end

		if love.keyboard.isDown("a") and px > 1 and mapData[(round(px)-1).."."..round(py)]["groundPassible"] == true then
			px = px - 1 * dt * playerSpeed
		end

		if love.keyboard.isDown("d") and px < 254 and mapData[(round(px)+1).."."..round(py)]["groundPassible"] == true then
			px = px + 1 * dt * playerSpeed
		end
	end
end

function love.draw()
	--[
	for X=0,gx do
		for Y=0,gy do
			local rX = round((px-10)+X) --the x coord
			local rY = round((py-8)+Y) --the y coord
			local coord = mapData[rX.."."..rY] --the coord for the tile

			if rX >= 0 and rX <= 255 and --checks for valid coords in X
			   rY >= 0 and rY <= 255 then--checks for valid coords in Y

				if coord["w"] ~= nil then --checks if wall
					love.graphics.draw(
					coord["w"][1], --fetch wall tile to render
					(32*X)-32, --x offset
					(32*Y)-32 --y offset
					)
				elseif coord["f"] ~= nil then --checks if floor
					love.graphics.draw(
					coord["f"][1], --fetch floor tile to render
					(32*X)-32, --x offset
					(32*Y)-32 --y offset
					)
				end
			end

			if coord["w"] ~= nil and coord["w"][2] == true then --check for wall and if that wall occludes
				love.graphics.line((dx-300)/2, (dy/2), X*32, Y*32) --draw line to bottem right corner of wall
			end
		end
	end--]]

	--[[]
	for i=0,(dx-300)/32 do
		love.graphics.line(0, 32*(i), dx-300, 32*(i)) --vertical lines
		love.graphics.line(32*(i), 0, 32*(i), dy) --horizontal lines
	end--]]

	love.graphics.circle("fill", (dx-300)/2, (dy/2), 16)

	--[[
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.line(0, 0, dx-300, dy)
	love.graphics.line(0, dy, dx-300, 0)
	love.graphics.line(0, dy/2, dx-300, dy/2)
	love.graphics.line((dx-300)/2, 0, (dx-300)/2, dy)
	love.graphics.setColor(1, 1, 1, 1)
	--]]

	love.graphics.printf(tostring(playerText), dx-295, 30, 300, "left")
	love.graphics.print("fps="..love.timer.getFPS(), dx-54, 5)
	love.graphics.print("X="..round(px), dx-44, 15)
	love.graphics.print("Y="..round(py), dx-44, 25)
end
