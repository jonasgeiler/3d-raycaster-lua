local bit = bit
local math = math
local fenster = require('fenster')
local utils = require('lib.utils')
local ppm = require('lib.ppm')

-- Define/load the textures
local texture_width ---@type integer
local texture_height ---@type integer
local texture = {} ---@type table<integer, integer[]>
texture[1], texture_width, texture_height = ppm.load('assets/eagle.ppm')
texture[2] = ppm.load('assets/redbrick.ppm')
texture[3] = ppm.load('assets/purplestone.ppm')
texture[4] = ppm.load('assets/greystone.ppm')
texture[5] = ppm.load('assets/bluestone.ppm')
texture[6] = ppm.load('assets/mossy.ppm')
texture[7] = ppm.load('assets/wood.ppm')
texture[8] = ppm.load('assets/colorstone.ppm')
texture[9] = ppm.load('assets/barrel.ppm')
texture[10] = ppm.load('assets/pillar.ppm')
texture[11] = ppm.load('assets/greenlight.ppm')
texture[12] = ppm.load('assets/house.ppm')
local floor_texture = texture[4]
local ceiling_texture = texture[7]

-- Define the world map
---@type integer[][] 2D array with 0 for empty space and other numbers for specific wall textures as defined above
local world_map = {
	{ 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 4, 6, 4, 4, 6, 4, 6, 4, 4, 4, 6, 4 },
	{ 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4 },
	{ 8, 0, 3, 3, 0, 0, 0, 0, 0, 8, 8, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6 },
	{ 8, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6 },
	{ 8, 0, 3, 3, 0, 0, 0, 0, 0, 8, 8, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4 },
	{ 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 4, 0, 0, 0, 0, 0, 6, 6, 6, 0, 6, 4, 6 },
	{ 8, 8, 8, 8, 0, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 4, 4, 6, 0, 0, 0, 0, 0, 6 },
	{ 7, 7, 7, 7, 0, 7, 7, 7, 7, 0, 8, 0, 8, 0, 8, 0, 8, 4, 0, 4, 0, 6, 0, 6 },
	{ 7, 7, 0, 0, 0, 0, 0, 0, 7, 8, 0, 8, 0, 8, 0, 8, 8, 6, 0, 0, 0, 0, 0, 6 },
	{ 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 6, 0, 0, 0, 0, 0, 4 },
	{ 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 6, 0, 6, 0, 6, 0, 6 },
	{ 7, 7, 0, 0, 0, 0, 0, 0, 7, 8, 0, 8, 0, 8, 0, 8, 8, 6, 4, 6, 0, 6, 6, 6 },
	{ 7, 7, 7, 7, 0, 7, 7, 7, 7, 8, 8, 4, 0, 6, 8, 4, 8, 3, 3, 3, 0, 3, 3, 3 },
	{ 2, 2, 2, 2, 0, 2, 2, 2, 2, 4, 6, 4, 0, 0, 6, 0, 6, 3, 0, 0, 0, 0, 0, 3 },
	{ 2, 2, 0, 0, 0, 0, 0, 2, 2, 4, 0, 0, 0, 0, 0, 0, 4, 3, 0, 0, 0, 0, 0, 3 },
	{ 2, 0, 0, 0, 0, 0, 0, 0, 2, 4, 0, 0, 0, 0, 0, 0, 4, 3, 0, 0, 0, 0, 0, 3 },
	{ 1, 0, 0, 0, 0, 0, 0, 0, 1, 4, 4, 4, 4, 4, 6, 0, 6, 3, 3, 0, 0, 0, 3, 3 },
	{ 2, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 1, 2, 2, 2, 6, 6, 0, 0, 5, 0, 5, 0, 5 },
	{ 2, 2, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 2, 2, 0, 5, 0, 5, 0, 0, 0, 5, 5 },
	{ 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 5, 0, 5, 0, 5, 0, 5, 0, 5 },
	{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5 },
	{ 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 5, 0, 5, 0, 5, 0, 5, 0, 5 },
	{ 2, 2, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 2, 2, 0, 5, 0, 5, 0, 0, 0, 5, 5 },
	{ 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 5, 5, 5, 5, 5, 5, 5, 5, 5 },
}
--local map_width = #world_map[1]
--local map_height = #world_map

-- Define sprites
---@type [number, number, integer][] Array with [x, y, texture] for each sprite - textures are as defined above
local sprites = {
	-- Green light in front of playerstart
	{ 20.5, 11.5, 11 },

	-- Green lights in every room
	{ 18.5, 4.5,  11 },
	{ 10.0, 4.5,  11 },
	{ 10.0, 12.5, 11 },
	{ 3.5,  6.5,  11 },
	{ 3.5,  20.5, 11 },
	{ 3.5,  14.5, 11 },
	{ 14.5, 20.5, 11 },

	-- Row of pillars in front of wall (fisheye test)
	{ 18.5, 10.5, 10 },
	{ 18.5, 11.5, 10 },
	{ 18.5, 12.5, 10 },

	-- Some barrels around the map
	{ 21.5, 1.5,  9 },
	{ 15.5, 1.5,  9 },
	{ 16.0, 1.8,  9 },
	{ 16.2, 1.2,  9 },
	{ 9.5,  15.5, 9 },
	{ 10.0, 15.1, 9 },
	{ 10.5, 15.8, 9 },

	-- Easter egg
	{ 3.5,  2.5,  12 },
}
local num_sprites = #sprites

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
local window_width = 320
assert(window_width % 2 == 0, 'Window width must be even')
local window_height = 240
assert(window_height % 2 == 0, 'Window height must be even')
local window_scale = 4
local window = fenster.open(
	window_width,
	window_height,
	'3D Raycaster - Press ESC to exit, arrow keys to move',
	window_scale
)
local window_width_half = math.floor(window_width / 2)
local window_height_half = math.floor(window_height / 2)

-- Init Z-Buffer, a 1D array to keep track of the depth of the pixels
local z_buffer = {} ---@type number[]

-- Arrays used to sort the sprites
local sprite_order = {} ---@type integer[]
local sprite_distance = {} ---@type number[]

-- Main window loop
while window:loop() do
	-- Timing for input and FPS counter
	local delta_time = window.delta

	-- Speed modifiers
	local move_speed = delta_time * 3.0 -- The constant value is in squares/second
	local rot_speed = delta_time * 2.0 -- The constant value is in radians/second

	-- Handle input
	local keys = window.keys
	if keys[27] then -- Esc, exit when pressed
		break
	end
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

	-- Floor/Ceiling raycasting
	for y = 0, window_height - 1 do
		-- Ray direction for leftmost ray (x = 0) and rightmost ray (x = w)
		local ray_dir_x0 = dir_x - plane_x
		local ray_dir_y0 = dir_y - plane_y
		local ray_dir_x1 = dir_x + plane_x
		local ray_dir_y1 = dir_y + plane_y

		-- Current Y position compared to the center of the screen (the horizon)
		local p = y - window_height_half

		-- Vertical position of the camera
		local pos_z = window_height_half ---@type number

		-- Horizontal distance from the camera to the floor for the current row
		-- (0.5 is the z position exactly in the middle between floor and ceiling)
		local row_distance = p == 0 and 0 or pos_z / p

		-- Calculate the real world step vector we have to add for each x (parallel to camera plane)
		-- adding step by step avoids multiplications with a weight in the inner loop
		local floor_step_x = row_distance * (ray_dir_x1 - ray_dir_x0) / window_width
		local floor_step_y = row_distance * (ray_dir_y1 - ray_dir_y0) / window_width

		-- Real world coordinates of the leftmost column - this will be updated as we step through the columns
		local floor_x = pos_x + row_distance * ray_dir_x0
		local floor_y = pos_y + row_distance * ray_dir_y0

		for x = 0, window_width - 1 do
			-- The cell coord is simply got from the integer parts of floor_x and floor_y
			local cell_x = utils.trunc(floor_x)
			local cell_y = utils.trunc(floor_y)

			-- Get the texture coordinate from the fractional part
			local texture_x = bit.band(utils.trunc(texture_width * (floor_x - cell_x)), texture_width - 1)
			local texture_y = bit.band(utils.trunc(texture_height * (floor_y - cell_y)), texture_height - 1)

			floor_x = floor_x + floor_step_x
			floor_y = floor_y + floor_step_y

			-- Draw floor
			local color = floor_texture[texture_height * texture_y + texture_x + 1]
			color = bit.band(bit.rshift(color, 1), 0x7F7F7F)
			window:set(x, y, color)

			-- Draw ceiling (symmetrical, at window_height - y - 1 instead of y)
			color = ceiling_texture[texture_height * texture_y + texture_x + 1]
			color = bit.band(bit.rshift(color, 1), 0x7F7F7F)
			window:set(x, window_height - y - 1, color)
		end
	end

	-- Wall raycasting
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
		local draw_start = utils.trunc(-line_height / 2) + window_height_half
		if draw_start < 0 then
			draw_start = 0
		end
		local draw_end = math.floor(line_height / 2) + window_height_half
		if draw_end >= window_height then
			draw_end = window_height
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
		local texture_pos = (draw_start - window_height_half + line_height / 2) * step

		for y = draw_start, draw_end - 1 do
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

		-- Set Z-buffer for the sprite casting
		z_buffer[x + 1] = perp_wall_dist
	end

	-- Sprite sorting
	for i = 1, num_sprites do
		sprite_order[i] = i
		sprite_distance[i] = (pos_x - sprites[i][1]) ^ 2 + (pos_y - sprites[i][2]) ^ 2
	end
	local swapped = true
	while swapped do
		swapped = false

		-- Sort the sprites based on distance
		for i = 1, num_sprites - 1 do -- Substract 1 because we compare the current sprite and the next one
			if sprite_distance[i] < sprite_distance[i + 1] then
				sprite_distance[i], sprite_distance[i + 1] = sprite_distance[i + 1], sprite_distance[i]
				sprite_order[i], sprite_order[i + 1] = sprite_order[i + 1], sprite_order[i]
				swapped = true
			end
		end
	end

	-- Sprite drawing
	for i = 1, num_sprites do
		-- Translate sprite position to relative to camera
		local sprite_x = sprites[sprite_order[i]][1] - pos_x
		local sprite_y = sprites[sprite_order[i]][2] - pos_y

		-- Inverse camera matrix
		local inv_det = 1.0 / (plane_x * dir_y - dir_x * plane_y) -- Required for correct matrix multiplication

		-- Transform sprite with the inverse camera matrix
		-- (These are actually the depth inside the screen, that what Z is in 3D)
		local transform_x = inv_det * (dir_y * sprite_x - dir_x * sprite_y)
		local transform_y = inv_det * (-plane_y * sprite_x + plane_x * sprite_y)

		-- Calculate width/height of the sprite on screen
		local sprite_size = math.abs(utils.trunc(window_height / transform_y)) -- Using "transform_y" instead of the real distance prevents fisheye

		-- Calculate lowest and highest pixel to fill in current stripe
		local draw_start_y = utils.trunc(-sprite_size / 2) + window_height_half
		if draw_start_y < 0 then
			draw_start_y = 0
		end
		local draw_end_y = math.floor(sprite_size / 2) + window_height_half
		if draw_end_y >= window_height then
			draw_end_y = window_height
		end

		local sprite_screen_x = utils.trunc(window_width_half * (1 + transform_x / transform_y))

		-- Calculate lowest and highest pixel to fill in current stripe
		local draw_start_x = utils.trunc(-sprite_size / 2) + sprite_screen_x
		if draw_start_x < 0 then
			draw_start_x = 0
		end
		local draw_end_x = math.floor(sprite_size / 2) + sprite_screen_x
		if draw_end_x >= window_width then
			draw_end_x = window_width
		end

		-- Loop through every vertical stripe of the sprite on screen
		for stripe = draw_start_x, draw_end_x - 1 do
			local texture_x = math.floor(
				math.floor(256 * (stripe - (-sprite_size / 2 + sprite_screen_x)) * texture_width / sprite_size) / 256
			)

			-- The conditions in the if are:
			-- 1) It's in front of camera plane so you don't see things behind you
			-- 2) It's on the screen (left)
			-- 3) It's on the screen (right)
			-- 4) Z-buffer, with perpendicular distance
			if transform_y > 0 and stripe > 0 and stripe < window_width and transform_y < z_buffer[stripe + 1] then
				-- For every pixel of the current stripe
				for y = draw_start_y, draw_end_y - 1 do
					local d = y * 256 - window_height * 128 + sprite_size * 128 -- 256 and 128 factors to avoid floats
					local texture_y = math.floor(((d * texture_height) / sprite_size) / 256)

					-- Get the color from the texture
					local color = texture[sprites[sprite_order[i]][3]][texture_height * texture_y + texture_x + 1]
					if color ~= 0 then -- Paint pixel if it isn't black, black is the invisible color
						window:set(stripe, y, color)
					end
				end
			end
		end
	end

	-- Draw lightweight FPS indicator
	--[[
	local fps = math.floor(1 / delta_time)
	for x = 0, math.min(120, fps) do
		window:set(x, 0, 0x00ff00)
	end
	window:set(30, 0, 0x0000ff)
	window:set(60, 0, 0xff0000)
	]]--
end
