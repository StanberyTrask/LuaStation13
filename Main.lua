require "load"
require "maps.luabase"
local lighter = require "plugins.lighter"
local utf8 = require "utf8"

function love.load()
	p1 = love.graphics.newImage("sprites/effects/parallax/layer1_0.png")
	p2 = love.graphics.newImage("sprites/effects/parallax/layer2_0.png")
	p3 = love.graphics.newImage("sprites/effects/parallax/layer3_0.png")
	arrow = love.graphics.newImage("sprites/UI/arrow.png")
	cable0001 = love.graphics.newImage("sprites/objects/electric_cable/l1-1_0.png")
	playerData = {
		["inGame"] = true,
		["facing"] = 0,
		["inventory"] = {
			["left"] = nil,
			["right"] = nil,
			["pocket1"] = nil,
			["pocket2"] = nil,
			["belt"] = nil,
			["id"] = nil,
			["pda"] = nil,
			["backpack"] = nil
		},
	}
	playerSpeed = 20 --multipier of the player speed
	courier = love.graphics.newFont("09809_COURIER.ttf", 20)
	px, py = 25, 25 --current player coordinates
	gx, gy = 19, 15 --the number of grids the player can see
	dx, dy = (gx*32) + 300, gy*32 --disply size in pixels
	love.window.setMode(dx, dy, {resizable = false}) --sets window scale
	isTyping = false
	chatHistory, mesageNumber, playerText = {}, 0, ""
	test = {32, 32, 64, 64, 128, 128}
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
		if love.keyboard.isDown("w") then
			playerData["facing"] = 0
			if py > 1 and mapData[round(px).."."..(round(py)-1)]["groundPassible"] == true then
				py = py - 1 * dt * playerSpeed
			end
		end

		if love.keyboard.isDown("s") then
			playerData["facing"] = math.pi
			if py < 254 and mapData[round(px).."."..(round(py)+1)]["groundPassible"] == true then
				py = py + 1 * dt * playerSpeed
			end
		end

		if love.keyboard.isDown("a") then
			playerData["facing"] = math.pi*1.5
			if px > 1 and mapData[(round(px)-1).."."..round(py)]["groundPassible"] == true then
				px = px - 1 * dt * playerSpeed
			end
		end

		if love.keyboard.isDown("d") then
			playerData["facing"] = math.pi/2
			if px < 254 and mapData[(round(px)+1).."."..round(py)]["groundPassible"] == true then
				px = px + 1 * dt * playerSpeed
			end
		end
	end
end

function love.draw()

	love.graphics.draw(p1, 0, 0, 0, 5, 5)
	for X=0,gx do --tile drawing
		for Y=0,gy do
			local rX = round((px-10)+X) --the x coord
			local rY = round((py-8)+Y) --the y coord
			local coord = mapData[rX.."."..rY] --the coord for the tile

			if rX >= 0 and rX <= 255 and --checks for valid coords in X
			   rY >= 0 and rY <= 255 and --checks for valid coords in Y
			   coord["occluded"] == false then

				if coord["w"] ~= nil then --checks if wall
					love.graphics.draw(
					coord["w"][1], --fetch wall tile to draw
					(32*X)-32, --x offset
					(32*Y)-32 --y offset
					)
				elseif coord["f"] ~= nil then --checks if floor
					love.graphics.draw(
					coord["f"][1], --fetch floor tile to draw
					(32*X)-32, --x offset
					(32*Y)-32 --y offset
					)
				end
			end
		end
	end

--[
	square = {}
	poly = {}
	f = 0
	g = 1
	for X=1,gx do --search in X
		for Y=1,gy do --seach in Y
			local aX = round((px-10)+X) --the absolute x coord
			local aY = round((py-8)+Y) --the absolute y coord
			local coord = mapData[aX.."."..aY] --the coord for the tile
			local rX = aX - round(px) --the relative distance from the tile to the player
			local rY = aY - round(py) --read above ^

			if aX >= 0 and aX <= 255 and --checks for valid coords in X
			aY >= 0 and aY <= 255 and--checks for valid coords in Y
			coord["w"] ~= nil and coord["w"][2] == true then --check for wall and if that wall occludes
				square[f] = { --grab the corners of the wall
					[1] = {(32*X)-32, (32*Y)-32}, --top left corner
					[2] = {32*X, (32*Y)-32}, --top right corner
					[3] = {32*X, 32*Y}, --bottom right corner
					[4] = {(32*X)-32, 32*Y} --bottom left corner
				}
				for i=1,#square[f] do --calculate the distance from player
					square[f][i][3] = rightTriangleC(square[f][i][1]-((dx-300)/2), square[f][i][2]-(dy/2))
				end
				local raw = {
					[1] = square[f][1],
					[2] = square[f][2],
					[3] = square[f][3],
					[4] = square[f][4]
				}
				table.sort(square[f], function(a,b) return a[3] > b[3] end) --sort from largest smallest

				love.graphics.setColor(0, 1, 0, 1)
				if adjacentPermutation(aX, aY) == "0000" then --empty
					if rX == 0 or rY == 0 then
						love.graphics.points(
						square[f][1][1], square[f][1][2],
						square[f][2][1], square[f][2][2],
						square[f][3][1], square[f][3][2],
						square[f][4][1], square[f][4][2]
					)
					else
						love.graphics.points(
						square[f][1][1], square[f][1][2],
						square[f][2][1], square[f][2][2],
						square[f][3][1], square[f][3][2]
					)
					end
				end

				if adjacentPermutation(aX, aY) == "0001" then --top
					if rX > 0 then --if to right
						love.graphics.points(
						raw[2][1], raw[2][2],
						raw[3][1], raw[3][2]
					)
					elseif rX == 0 and rY < 0 then --if above
						love.graphics.points(
						raw[1][1], raw[1][2],
						raw[2][1], raw[2][2]
					)
					elseif rX < 0 then --if to left
						love.graphics.points(
						raw[1][1], raw[1][2],
						raw[4][1], raw[4][2]
					)
					end
				end

				if adjacentPermutation(aX, aY) == "0010" then --bottom
					if rX > 0 then --if to right
						love.graphics.points(
						raw[2][1], raw[2][2],
						raw[3][1], raw[3][2]
					)
					elseif rX == 0 and rY > 0 then --if below
						love.graphics.points(
						raw[3][1], raw[3][2],
						raw[4][1], raw[4][2]
					)
					elseif rX < 0 then --if to left
						love.graphics.points(
						raw[1][1], raw[1][2],
						raw[4][1], raw[4][2]
					)
					end
				end

				if adjacentPermutation(aX, aY) == "0011" then --top botom
					if rX > 0 then --if to right
						love.graphics.points(
						raw[2][1], raw[2][2],
						raw[3][1], raw[3][2]
					)
					elseif rX < 0 then --if to left
						love.graphics.points(
						raw[1][1], raw[1][2],
						raw[4][1], raw[4][2]
					)
					end
				end

				if adjacentPermutation(aX, aY) == "0100" then --left
					if rY > 0 then --if above
						love.graphics.points(
						raw[3][1], raw[3][2],
						raw[4][1], raw[4][2]
					)
					elseif rX < 0 and rY == 0 then --if to right and level
						love.graphics.points(
						raw[1][1], raw[1][2],
						raw[4][1], raw[4][2]
					)
					elseif rY < 0 then --if below
						love.graphics.points(
						raw[1][1], raw[1][2],
						raw[2][1], raw[2][2]
					)
					end
				end

				if adjacentPermutation(aX, aY) == "0101" then --left top
					if rX < 0 and rY >= 0 then --if to right and above
						love.graphics.points(
						raw[1][1], raw[1][2],
						raw[4][1], raw[4][2]
					)
					elseif rX >= 0 and rY < 0 then --if to left and below
						love.graphics.points(
						raw[1][1], raw[1][2],
						raw[2][1], raw[2][2]
					)
					end
				end

				if adjacentPermutation(aX, aY) == "0110" then --left bottom

				end

				if adjacentPermutation(aX, aY) == "0111" then --left bottom top

				end

				if adjacentPermutation(aX, aY) == "0111" then --right

				end
				love.graphics.setColor(1, 1, 1, 1)
				f = f + 1
			end
		end
	end
--]]
--[[
	for X=1,gx do
		for Y=1,gy do

			local rX = round((px-10)+X) --the x coord
			local rY = round((py-8)+Y) --the y coord
			local coord = mapData[rX.."."..rY] --the coord for the tile
			local A = (Y*32) - (dy/2) - 16
			local B = (X*32) - ((dx-300)/2) - 16
			if rX >= 0 and rX <= 255 and --checks for valid coords in X
			rY >= 0 and rY <= 255 and--checks for valid coords in Y
			coord["w"] ~= nil and coord["w"][2] == true then --check for wall and if that wall occludes
				--love.graphics.print(linextrap(dx-300, (dx-300)/2, dy/2, (X*32)-32, (Y*32)-32), 5, 5)
				love.graphics.setColor(0, 0, 0, 1)
				--[[
				love.graphics.line((dx-300)/2, (dy/2), 0, linextrap(0, (dx-300)/2, dy/2, X*32, Y*32)) --draw line to bottem right corner
				love.graphics.line((dx-300)/2, (dy/2), 0, linextrap(0, (dx-300)/2, dy/2, X*32, (Y*32)-32)) --draw line to top right
				love.graphics.line((dx-300)/2, (dy/2), 0, linextrap(0, (dx-300)/2, dy/2, (X*32)-32, (Y*32)-32)) --draw line to top left
				love.graphics.line((dx-300)/2, (dy/2), 0, linextrap(0, (dx-300)/2, dy/2, (X*32)-32, Y*32)) --draw line to bottom left
				--]]
				--[[
				if rX > round(px) and rY < round(py) then
					shadowPoints = {
						(X*32)-32, (Y*32)-32,
						X*32, (Y*32)-32,
						X*32, Y*32,
						dx-300, linextrap(dx-300, (dx-300)/2, dy/2, X*32, Y*32),
						dx-300, 0,
						dx-300, linextrap(dx-300, (dx-300)/2, dy/2, (X*32)-32, (Y*32)-32)
					}

					triangles = love.math.triangulate(shadowPoints)

					for i=1,tablelength(triangles) do
						love.graphics.polygon("fill", triangles[i])
					end

				elseif rX < round(px) and rY < round(py) then
					shadowPoints = {
						X*32, (Y*32)-32,
						(X*32)-32, (Y*32)-32,
						(X*32)-32, Y*32,
						0, linextrap(0, (dx-300)/2, dy/2, (X*32)-32, Y*32),
						0, 0,
						0, linextrap(0, (dx-300)/2, dy/2, X*32, (Y*32)-32)
					}

					triangles = love.math.triangulate(shadowPoints)

					for i=1,tablelength(triangles) do
						love.graphics.polygon("fill", triangles[i])
					end

				elseif rX == round(px) and rY < round(py) then
					shadowPoints = {
						(X*32)-32, Y*32,
						(X*32)-32, (Y*32)-32,
						X*32, (Y*32)-32,
						X*32, Y*32,
						dx-300, linextrap(dx-300, (dx-300)/2, dy/2, X*32, Y*32),
						0, linextrap(0, (dx-300)/2, dy/2, (X*32)-32, Y*32)
					}

					triangles = love.math.triangulate(shadowPoints)

					for i=1, tablelength(triangles) do
						love.graphics.polygon("fill", triangles[i])
					end
				end
				love.graphics.setColor(1, 1, 1, 1)
			end
		end
	end
	--]] --shadow code, WIP (?)

	love.graphics.circle("fill", (dx-300)/2, (dy/2), 16)
	love.graphics.draw(arrow, ((dx-300)/2), (dy/2), playerData["facing"], 1, 1, 16, 16)

	love.graphics.draw(pockets, 32*5, dy-50)
	love.graphics.printf(tostring(playerText), dx-295, 30, 300, "left")
	love.graphics.print("fps="..love.timer.getFPS(), dx-54, 5)
	love.graphics.print("X="..round(px), dx-44, 15)
	love.graphics.print("Y="..round(py), dx-44, 25)
	love.graphics.print(playerData["facing"], dx-44, 35)
	love.graphics.draw(ec00000, 64-16, 64-16, 0, 1, 1, 16, 16)
end
