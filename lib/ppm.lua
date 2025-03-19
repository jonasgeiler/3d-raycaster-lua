local assert = assert
local tostring = tostring
local io = io
local string = string
local table = table
local fenster = require('fenster')

local ppm = {}

---Load a PPM image.
---@param path string
---@return integer[]
---@return integer
---@return integer
---@nodiscard
function ppm.load(path)
	local image = assert(io.open(path, 'rb'))

	local image_type = image:read(2)
	assert(image_type == 'P6', 'Invalid image type: ' .. tostring(image_type))
	assert(image:read(1), 'Invalid image header') -- Whitespace
	local image_width = image:read('*number')
	assert(image_width, 'Invalid image width: ' .. tostring(image_width))
	assert(image:read(1), 'Invalid image header') -- Whitespace
	local image_height = image:read('*number')
	assert(image_height, 'Invalid image height: ' .. tostring(image_height))
	assert(image:read(1), 'Invalid image header') -- Whitespace
	local image_max_color = image:read('*number')
	assert(
		image_max_color == 255,
		'Invalid image maximum color: ' .. tostring(image_max_color)
	)
	assert(image:read(1), 'Invalid image header') -- Whitespace

	local image_buffer = {} ---@type integer[]
	while true do
		local r_raw = image:read(1)
		local g_raw = image:read(1)
		local b_raw = image:read(1)
		if not r_raw or not g_raw or not b_raw then
			break
		end

		local r = string.byte(r_raw)
		local g = string.byte(g_raw)
		local b = string.byte(b_raw)
		table.insert(image_buffer, fenster.rgb(r, g, b))
	end

	image:close()
	return image_buffer, image_width, image_height
end

return ppm
