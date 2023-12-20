utils = {}
do
	local function serializeValue(value, depth)
		local res = ''
		if type(value)=='number' or type(value)=='boolean' then
			res = res..tostring(value)
		elseif type(value)=='string' then
			res = res..'"'..value:gsub("\\","\\\\"):gsub("\n","\\\n"):gsub("\"","\\\"")..'"'
		elseif type(value)=='table' then
			res = res..'\n'
			for d = 1,depth,1 do res=res..'    ' end
			res = res..'{\n'
			local set = false
			for i,v in pairs(value) do
				for d = 1,depth+1,1 do res=res..'    ' end
				if type(i)=='number' then
					res = res..'['..i..']='..serializeValue(v, depth+1)..',\n'
					set = true
				else
					res = res..'[\''..i..'\']='..serializeValue(v, depth+1)..','
					if type(v)=='table' then
						res=res..' -- end of ["'..i..'"]'
					end
					res = res..'\n'
					set = true
				end
			end
			res = res:sub(1,-2)
			res = res..'\n'
			for d = 1,depth,1 do res=res..'    ' end
			res = res..'}'
		end
		return res
	end

	function utils.saveTable(filename, variablename, data)
		local str = variablename..' = '..serializeValue(data, 0)..' -- end of ["'..variablename..'"]'
		
		File = io.open(filename, "w")
		File:write(str)
		File:close()
	end
end
