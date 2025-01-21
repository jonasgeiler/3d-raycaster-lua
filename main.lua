local bit = bit
local math = math
local fenster = require('fenster')

-- Define the world map
--local map_width = 24
--local map_height = 24
local world_map = {
	{ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 7, 7, 7, 7, 7, 7, 7, 7 },
	{ 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 7 },
	{ 4, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7 },
	{ 4, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7 },
	{ 4, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 7 },
	{ 4, 0, 4, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 7, 7, 0, 7, 7, 7, 7, 7 },
	{ 4, 0, 5, 0, 0, 0, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 7, 0, 0, 0, 7, 7, 7, 1 },
	{ 4, 0, 6, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 5, 7, 0, 0, 0, 0, 0, 0, 8 },
	{ 4, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 7, 1 },
	{ 4, 0, 8, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 5, 7, 0, 0, 0, 0, 0, 0, 8 },
	{ 4, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 5, 7, 0, 0, 0, 7, 7, 7, 1 },
	{ 4, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 0, 5, 5, 5, 5, 7, 7, 7, 7, 7, 7, 7, 1 },
	{ 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 },
	{ 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4 },
	{ 6, 6, 6, 6, 6, 6, 0, 6, 6, 6, 6, 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 },
	{ 4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 6, 0, 6, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3 },
	{ 4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 0, 6, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2 },
	{ 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 2, 0, 0, 5, 0, 0, 2, 0, 0, 0, 2 },
	{ 4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 0, 6, 2, 0, 0, 0, 0, 0, 2, 2, 0, 2, 2 },
	{ 4, 0, 6, 0, 6, 0, 0, 0, 0, 4, 6, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 2 },
	{ 4, 0, 0, 5, 0, 0, 0, 0, 0, 4, 6, 0, 6, 2, 0, 0, 0, 0, 0, 2, 2, 0, 2, 2 },
	{ 4, 0, 6, 0, 6, 0, 0, 0, 0, 4, 6, 0, 6, 2, 0, 0, 5, 0, 0, 2, 0, 0, 0, 2 },
	{ 4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 0, 6, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2 },
	{ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3 },
}

-- Define/calculate the textures
local texture_width = 64
local texture_height = 64
local texture = { {}, {}, {}, {}, {}, {}, {}, {} } ---@type table<integer, table<integer, integer>>
for y = 0, texture_height - 1 do
	for x = 0, texture_width - 1 do
		local xor_color = bit.bxor(math.floor(x * 256 / texture_width), math.floor(y * 256 / texture_height))
		--local x_color = math.floor(x * 256 / texture_width)
		local y_color = math.floor(y * 256 / texture_height)
		local xy_color = math.floor(y * 128 / texture_height + x * 128 / texture_width)

		local i = texture_height * y + x + 1
		texture[1][i] = 65536 * 254 * ((x ~= y and x ~= texture_width - y) and 1 or 0) -- flat red with black cross
		texture[2][i] = xy_color + 256 * xy_color + 65536 * xy_color -- sloped greyscale
		texture[3][i] = 256 * xy_color + 65536 * xy_color -- sloped yellow gradient
		texture[4][i] = xor_color + 256 * xor_color + 65536 * xor_color -- xor greyscale
		texture[5][i] = 256 * xor_color -- xor green
		texture[6][i] = 65536 * 192 * ((x % 16 > 0 and y % 16 > 0) and 1 or 0) -- red bricks
		texture[7][i] = 65536 * y_color -- red gradient
		texture[8][i] = 128 + 256 * 128 + 65536 * 128 -- flat grey texture
	end
end

-- Initial position
local pos_x = 22 ---@type number
local pos_y = 11.5 ---@type number

-- Initial direction vector
local dir_x = -1 ---@type number
local dir_y = 0 ---@type number

-- The 2D raycaster version of camera plane
local plane_x = 0 ---@type number
local plane_y = 0.66 ---@type number

-- Create a window
local window_width = 640
local window_height = 480
local window_scale = 2
local window = fenster.open(
	window_width,
	window_height,
	'3D Raycaster - Press ESC to exit, arrow keys to move',
	window_scale
)

-- Main window loop
while window:loop() and not window.keys[27] do -- Exit on ESC
	window:clear()

	-- Timing for input and FPS counter
	local delta_time = window.delta

	-- Speed modifiers
	local move_speed = delta_time * 5.0 -- The constant value is in squares/second
	local rot_speed = delta_time * 3.0 -- The constant value is in radians/second

	-- Handle input
	local keys = window.keys
	if keys[17] then -- Up arrow, move forward if no wall in front of you
		if world_map[math.floor(pos_x + dir_x * move_speed) + 1][math.floor(pos_y) + 1] == 0 then
			pos_x = pos_x + dir_x * move_speed
		end
		if world_map[math.floor(pos_x) + 1][math.floor(pos_y + dir_y * move_speed) + 1] == 0 then
			pos_y = pos_y + dir_y * move_speed
		end
	end
	if keys[18] then -- Down arrow, move backwards if no wall behind you
		if world_map[math.floor(pos_x - dir_x * move_speed) + 1][math.floor(pos_y) + 1] == 0 then
			pos_x = pos_x - dir_x * move_speed
		end
		if world_map[math.floor(pos_x) + 1][math.floor(pos_y - dir_y * move_speed) + 1] == 0 then
			pos_y = pos_y - dir_y * move_speed
		end
	end
	if keys[19] then -- Right arrow, rotate to the right
		-- Both camera direction and camera plane must be rotated
		local old_dir_x = dir_x ---@type number
		dir_x = dir_x * math.cos(-rot_speed) - dir_y * math.sin(-rot_speed)
		dir_y = old_dir_x * math.sin(-rot_speed) + dir_y * math.cos(-rot_speed)
		local old_plane_x = plane_x ---@type number
		plane_x = plane_x * math.cos(-rot_speed) - plane_y * math.sin(-rot_speed)
		plane_y = old_plane_x * math.sin(-rot_speed) + plane_y * math.cos(-rot_speed)
	end
	if keys[20] then -- Left arrow, rotate to the left
		-- Both camera direction and camera plane must be rotated
		local old_dir_x = dir_x ---@type number
		dir_x = dir_x * math.cos(rot_speed) - dir_y * math.sin(rot_speed)
		dir_y = old_dir_x * math.sin(rot_speed) + dir_y * math.cos(rot_speed)
		local old_plane_x = plane_x ---@type number
		plane_x = plane_x * math.cos(rot_speed) - plane_y * math.sin(rot_speed)
		plane_y = old_plane_x * math.sin(rot_speed) + plane_y * math.cos(rot_speed)
	end

	-- Raycasting loop
	for x = 0, window_width - 1 do
		-- Calculate ray position and direction
		local camera_x = 2 * x / window_width - 1 -- x-coordinate in camera space
		local ray_dir_x = dir_x + plane_x * camera_x
		local ray_dir_y = dir_y + plane_y * camera_x

		-- Which box of the map we're in
		local map_x = math.floor(pos_x)
		local map_y = math.floor(pos_y)

		-- Length of ray from current position to next x or y-side
		local side_dist_x ---@type number
		local side_dist_y ---@type number

		-- Length of ray from one x or y-side to next x or y-side
		local delta_dist_x = ray_dir_x == 0 and math.huge or math.abs(1 / ray_dir_x)
		local delta_dist_y = ray_dir_y == 0 and math.huge or math.abs(1 / ray_dir_y)

		local perp_wall_dist ---@type number

		-- What direction to step in x or y-direction (either +1 or -1)
		local step_x ---@type integer
		local step_y ---@type integer

		local hit = 0 ---@type integer Was there a wall hit?
		local side ---@type integer Was a NS or a EW wall hit?

		-- Calculate step and initial side_dist
		if ray_dir_x < 0 then
			step_x = -1
			side_dist_x = (pos_x - map_x) * delta_dist_x
		else
			step_x = 1
			side_dist_x = (map_x + 1.0 - pos_x) * delta_dist_x
		end
		if ray_dir_y < 0 then
			step_y = -1
			side_dist_y = (pos_y - map_y) * delta_dist_y
		else
			step_y = 1
			side_dist_y = (map_y + 1.0 - pos_y) * delta_dist_y
		end

		-- Perform DDA
		while hit == 0 do
			-- Jump to next map square, either in x-direction, or in y-direction
			if side_dist_x < side_dist_y then
				side_dist_x = side_dist_x + delta_dist_x
				map_x = map_x + step_x
				side = 0
			else
				side_dist_y = side_dist_y + delta_dist_y
				map_y = map_y + step_y
				side = 1
			end

			if world_map[map_x + 1][map_y + 1] > 0 then
				hit = 1
			end
		end

		-- Calculate distance projected on camera direction (Euclidean distance will give fisheye effect!)
		if side == 0 then
			perp_wall_dist = (side_dist_x - delta_dist_x)
		else
			perp_wall_dist = (side_dist_y - delta_dist_y)
		end

		-- Calculate height of line to draw on screen
		local line_height = math.floor(window_height / perp_wall_dist)

		-- Calculate lowest and highest pixel to fill in current stripe
		local draw_start = math.floor(-line_height / 2 + window_height / 2)
		if draw_start < 0 then
			draw_start = 0
		end
		local draw_end = math.floor(line_height / 2 + window_height / 2)
		if draw_end >= window_height then
			draw_end = window_height - 1
		end

		-- Get texture to use
		local texture_num = world_map[map_x + 1][map_y + 1] -- We DON'T subtract 1 because Lua arrays are 1-indexed

		-- Calculate value of wall_x
		local wall_x ---@type number
		if side == 0 then
			wall_x = pos_y + perp_wall_dist * ray_dir_y
		else
			wall_x = pos_x + perp_wall_dist * ray_dir_x
		end
		wall_x = wall_x - math.floor(wall_x)

		-- X coordinate on the texture
		local texture_x = math.floor(wall_x * texture_width)
		if side == 0 and ray_dir_x > 0 then
			texture_x = texture_width - texture_x - 1
		end
		if side == 1 and ray_dir_y < 0 then
			texture_x = texture_width - texture_x - 1
		end

		-- How much to increase the texture coordinate per screen pixel
		local step = texture_height / line_height

		-- Starting texture coordinate
		local texture_pos = (draw_start - window_height / 2 + line_height / 2) * step

		for y = draw_start, draw_end do
			-- Floor the texture coordinate and mask with (texture_height - 1) in case of overflow
			local texture_y = bit.band(math.floor(texture_pos), texture_height - 1)
			texture_pos = texture_pos + step

			-- Get the color of the texture
			local color = texture[texture_num][texture_height * texture_y + texture_x + 1]

			-- Make color darker for y-sides: R, G and B byte each divided through two with a "shift" and an "and"
			if side == 1 then
				color = bit.band(bit.rshift(color, 1), 0x7F7F7F)
			end

			-- Draw the pixel
			window:set(x, y, color)
		end
	end

	-- FPS counter
	local fps = math.floor(1 / delta_time)
	for x = 0, math.min(120, fps) do
		window:set(x, 0, 0x00ff00)
	end
	window:set(30, 0, 0x0000ff)
	window:set(60, 0, 0xff0000)
end
