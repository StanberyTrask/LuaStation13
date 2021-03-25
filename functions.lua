function sign(x)
	return (x<0 and -1) or 1
end

function intToBin(int, width)
	local t, i = {}, 1
	if width == nil then width = 0 end
	if int == 0 then t[i] = "0" else
		while int ~= 0 do t[i], int, i = int%2, math.floor(int/2), i + 1 end
	end
	local string = table.concat(t):reverse()
	return string.rep("0", width-#string)..string
end

function round(number)
  if (number - (number % 0.1)) - (number - (number % 1)) < 0.5 then
    number = number - (number % 1)
  else
    number = (number - (number % 1)) + 1
  end
 return number
end

function linextrap(x, x1, y1, x2, y2)
	m = (y2-y1)/(x2-x1)
	return y1 + m * (x - x1)
end

function rightTriangleC(A, B)
	return math.sqrt(math.pow(A, 2)+math.pow(B, 2))
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function getAdjacent(rX, rY)
	local i = 0
	for k=1,4 do
		if k == 1 and mapData[(rX+1).."."..rY]["w"] ~= nil and mapData[(rX+1).."."..rY]["w"][2] == true then
			i = i + 1
		elseif k == 2 and mapData[(rX-1).."."..rY]["w"] ~= nil and mapData[(rX-1).."."..rY]["w"][2] == true then
			i = i + 1
		elseif k == 3 and mapData[rX.."."..(rY+1)]["w"] ~= nil and mapData[rX.."."..(rY+1)]["w"][2] == true then
			i = i + 1
		elseif k == 4 and mapData[rX.."."..(rY-1)]["w"] ~= nil and mapData[rX.."."..(rY-1)]["w"][2] == true then
			i = i + 1
		end
	end
	return i
end

function adjacentPermutation(rX, rY)
	if mapData[(rX+1).."."..rY]["w"] ~= nil and mapData[(rX+1).."."..rY]["w"][2] == true then --right
		s1 = "1"
	else s1 = "0" end
	if mapData[(rX-1).."."..rY]["w"] ~= nil and mapData[(rX-1).."."..rY]["w"][2] == true then --left
		s2 = "1"
	else s2 = "0" end
	if mapData[rX.."."..(rY+1)]["w"] ~= nil and mapData[rX.."."..(rY+1)]["w"][2] == true then --bottom
		s3 = "1"
	else s3 = "0" end
	if mapData[rX.."."..(rY-1)]["w"] ~= nil and mapData[rX.."."..(rY-1)]["w"][2] == true then --top
		s4 = "1"
	else s4 = "0" end
	return s1..s2..s3..s4
end
