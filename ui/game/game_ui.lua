function loadUi()
	gear = love.graphics.newImage("sprites/tiles/ui/Gear_ui.png")
	backpack = love.graphics.newImage("sprites/tiles/ui/item ui background.png")
end

function gearUi()
	local drawn = true
	local x, y = love.mouse.getPosition()
	local click = love.mouse.isDown(1)
		if x >= 15 and x <= 30 then
			drawn = false
		end
	if drawn == true then
		--love.graphics.draw(gear, 15, 440, 0, .4, .4)
	end
end
