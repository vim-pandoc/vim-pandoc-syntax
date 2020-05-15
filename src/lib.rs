#[macro_use]
extern crate mlua_derive;

use mlua::prelude::*;

fn hello(_: &Lua, name: String) -> LuaResult<String> {
    let a: String = String::from(format!("not you {} he he", name));
    Ok(a)
}

#[lua_module]
fn libvim_pandoc_syntax(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("hello", lua.create_function(hello)?)?;
    Ok(exports)
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
