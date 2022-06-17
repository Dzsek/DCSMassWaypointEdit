function isClient(units)
	for _,unit in ipairs(units) do
		if unit.skill == "Client" then
			return true
		end
	end

	return false
end


function getRouteFromGroup(groupname, countries)

	for _,country in ipairs(countries) do
		if country.plane and country.plane.group then
			for _,group in ipairs(country.plane.group) do
				if group.name == groupname then
					return group.route
				end
			end
		end
	end

end

function copyRoute(source, destination)
	for i,v in ipairs(source) do
		if i~=1 then
			destination[i] = v
		end
	end
end

function serializeValue(value)
	local res = ''
	if type(value)=='number' or type(value)=='boolean' then
		res = res..tostring(value)
	elseif type(value)=='string' then
		res = res..'"'..value:gsub("\\","\\\\"):gsub("\n","\\\n"):gsub("\"","\\\"")..'"'
	elseif type(value)=='table' then
		res = res..'{ '
		for i,v in pairs(value) do
			if type(i)=='number' then
				res = res..'['..i..']='..serializeValue(v)..','
			else
				res = res..'[\''..i..'\']='..serializeValue(v)..','
			end
		end
		res = res:sub(1,-2)
		res = res..' }'
	end
	return res
end

function saveTable(filename, variablename, data)
	local str = variablename..' = {}'
	for i,v in pairs(data) do
		str = str..'\n'..variablename..'["'..i..'"] = '..serializeValue(v)
	end

	File = io.open(filename, "w")
	File:write(str)
	File:close()
end




dofile('mission')
local countries = mission.coalition.blue.country
templateGroup = "route-template-group"

local route = getRouteFromGroup(templateGroup, countries)

if not route then 
	print("No group named 'route-template-group' found to copy waypoints from")
	os.exit()
end

for _,country in ipairs(countries) do
	if country.plane and country.plane.group then
		for _,group in ipairs(country.plane.group) do
			if isClient(group.units) then
				print(group.name)
				copyRoute(route.points, group.route.points)
			end
		end
	end

	if country.helicopter and country.helicopter.group then
		for _,group in ipairs(country.helicopter.group) do
			if isClient(group.units) then
				print(group.name)
				copyRoute(route.points, group.route.points)
			end
		end
	end
end

saveTable('mission2', 'mission', mission)
