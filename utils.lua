utils = {}
do
	local function serializeValue(value)
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

	function utils.saveTable(filename, variablename, data)
		local str = variablename..' = {}'
		for i,v in pairs(data) do
			str = str..'\n'..variablename..'["'..i..'"] = '..serializeValue(v)
		end

		File = io.open(filename, "w")
		File:write(str)
		File:close()
	end
end