local math = math
local utils = {}

---Truncate the decimal part of a number.
---@param n number
---@return integer
---@nodiscard
function utils.trunc(n)
	return n >= 0 and math.floor(n) or math.ceil(n)
end

return utils
