mapData = {}
for i=0,255 do
	for i2=0,255 do
		mapData[i.."."..i2] = {
			["groundPassible"] = true, --is tile passible from ground?
			["airPassible"] = true, --is tile passible from air?
			["occluded"] = false, --is the tile occluded?
			["f"] = nil, --current floor tile
			["w"] = nil, --current wall tile
			["p"] = {} --all player layer data
		}
	end
end

--[
for x=0, 255 do
	for y=0, 255 do
		mapData[x.."."..y]["f"] = steelFloor
	end
end
--]]

mapData["27.28"]["w"] = steelWall
mapData["27.27"]["w"] = steelWall
mapData["27.26"]["w"] = steelWall
mapData["27.25"]["w"] = steelWall
mapData["28.28"]["w"] = steelWall
mapData["28.27"]["w"] = steelWall
mapData["28.29"]["w"] = steelWall
mapData["29.28"]["w"] = steelWall

for X=0,255 do
	for Y=0, 255 do

		if mapData[X.."."..Y]["w"] ~= nil then
			if mapData[X.."."..Y]["w"]["groundPassible"] == false then
				mapData[X.."."..Y]["groundPassible"] = false
			end

			if mapData[X.."."..Y]["w"]["airPassible"] == false then
				mapData[X.."."..Y]["airPassible"] = false
			end
		end

		if mapData[X.."."..Y]["f"] ~= nil then
			if mapData[X.."."..Y]["f"]["groundPassible"] == false then
				mapData[X.."."..Y]["groundPassible"] = false
			end

			if mapData[X.."."..Y]["f"]["airPassible"] == false then
				mapData[X.."."..Y]["airPassible"] = false
			end
		end
	end
end
