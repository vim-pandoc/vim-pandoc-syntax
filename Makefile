.ONESHELL:

.PHONY: all
all: lua_lib python_lib links

.PHONY: lua_lib
lua_lib:
	export LUA_INC=/usr/include/luajit-2.0/
	export LUA_LIB=/usr/lib LUA_LIB_NAME=luajit-5.1
	export LUA_LINK=dynamic
	cargo build --no-default-features --features lua --target-dir target-lua

.PHONY: python_lib
python_lib:
	cargo build --no-default-features --features python --target-dir target-python

.PHONY: links

links: lua/libvim_pandoc_syntax.so python3/libvim_pandoc_syntax.so

lua/libvim_pandoc_syntax.so: lua_lib
	mkdir -p $(@D)
	ln -sf ../target-lua/debug/libvim_pandoc_syntax.so $@

python3/libvim_pandoc_syntax.so: python_lib
	mkdir -p $(@D)
	ln -sf ../target-python/debug/libvim_pandoc_syntax.so $@
