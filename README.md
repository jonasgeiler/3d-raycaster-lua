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

- LuaJIT 2.1 (_**highly recommended**_) or Lua 5.1 (newer Lua versions might work but not tested)
- If you use standard Lua you will also need the [Lua BitOp extension](https://bitop.luajit.org/), which is included in LuaJIT
- [LuaRocks](https://luarocks.org/)

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
