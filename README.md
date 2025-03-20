# 3d-raycaster-lua

> A Wolfenstein-like 3D raycaster written in Lua using
> using [lua-fenster](https://github.com/jonasgeiler/lua-fenster).

I wanted to learn more about how a simple 3D raycaster works, similar to the one Wolfenstein 3D used back in the day,
so I followed a tutorial by [Lode][lode] about [Raycasting][raycasting].

The code is a little unoptimized and nothing that could actually be turned into a game without a ton of work,
but it is a fun prototype written with my very own GUI library, [lua-fenster](https://github.com/jonasgeiler/lua-fenster).

All the code is written by me, but I added a [MIT license](./LICENSE.md) so feel free to use it
in any way you like.  
However, the Wolfenstein 3D textures I have used in this project are copyrighted by id Software.

[lode]: https://lodev.org
[raycasting]: https://lodev.org/cgtutor/raycasting.html

## Screenshots

![Screenshot 1](https://github.com/user-attachments/assets/3fad4457-6bf0-41a7-95c1-d5b71aca7757)
![Screenshot 2](https://github.com/user-attachments/assets/0dd1c550-24b8-4783-8a21-3e5797cdadcc)

## Requirements

- [LuaJIT 2.1](https://luajit.org/) (_**highly recommended**_) or [Lua 5.1](https://www.lua.org/) (newer Lua versions might work but not tested)
  > **💡 Tip:** On Arch Linux, you can easily install both with `pacman -S luajit lua51`.
- If you use standard Lua 5.1, you will also need the [Lua BitOp extension](https://bitop.luajit.org/), which is already included in LuaJIT 2.1
  > **💡 Tip:** On Arch Linux, you can easily install it with `pacman -S lua51-bitop`.
- [LuaRocks](https://luarocks.org/)
  > **💡 Tip:** On Arch Linux, you can easily install it with `pacman -S luarocks`.
  >
  > **💬 Important:** Make sure you configure LuaRocks to use Lua 5.1 (even when you use LuaJIT 2.1)
  > by either using the `--lua-version=5.1` flag every time, or by configuring it with `luarocks config lua_version 5.1`.

## How to try

Download the repository and install the dependencies with `luarocks`:

```shell
$ luarocks install --only-deps 3d-raycaster-dev-1.rockspec

# OR, manually install dependencies:
$ luarocks install fenster
```

Afterwards, run [`main.lua`](./main.lua):

```shell
$ luajit ./main.lua

# OR, if you have the Lua BitOp extension installed (see above):
$ lua5.1 ./main.lua
```

Feel free to play around with the [`main.lua`](./main.lua) file,
changing the map, textures, sprites and such.
