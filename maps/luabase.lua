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

mapData["127.128"]["w"] = steelWall
mapData["127.129"]["w"] = steelWall
mapData["127.130"]["w"] = steelWall
mapData["128.130"]["w"] = steelWall
mapData["129.130"]["w"] = steelWall

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
