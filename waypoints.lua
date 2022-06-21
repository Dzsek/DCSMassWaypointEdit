require("utils")

function isClient(units)
	for _,unit in ipairs(units) do
		if unit.skill == "Client" then
			return true
		end
	end

	return false
end

function shouldSkip(units)
	if not ignore then return false end

	for _,unit in ipairs(units) do
		if ignore[unit.type] then
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

function updateRoute(route, groups)
	for _,group in ipairs(groups) do
		if isClient(group.units) and not shouldSkip(group.units) then
			print("Updating "..group.name.." ["..group.units[1].type.."]")
			group.route.points = { group.route.points[1] }
			copyRoute(route.points, group.route.points)
		end
	end
end

dofile(arg[1])

dofile('ignore.lua')

for coalition,_ in pairs(mission.coalition) do
	local countries = mission.coalition[coalition].country
	templateGroup = "route-template-"..coalition

	local route = getRouteFromGroup(templateGroup, countries)

	if not route then 
		print("\nNo group named '"..templateGroup.."' found to copy waypoints from. Skipping coalition")
	else
		print("\nCopying '"..templateGroup.."'")
		for _,country in ipairs(countries) do
			if country.plane and country.plane.group then
				updateRoute(route, country.plane.group)
			end

			if country.helicopter and country.helicopter.group then
				updateRoute(route, country.helicopter.group)
			end
		end
	end
end

utils.saveTable(arg[2], 'mission', mission)