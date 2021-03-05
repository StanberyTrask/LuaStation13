file = io.open("maps/Luastation(raw).lua")
io.input(file)
string = ""
mapTable = {}
i=1
while string ~= nil do
	string = io.read()
	mapTable[i] = string
	i = i + 1
end
