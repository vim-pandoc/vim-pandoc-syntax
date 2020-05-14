#[macro_use]
extern crate mlua_derive;

use mlua::prelude::*;
use pulldown_cmark::{Options, Parser};

fn hello(_: &Lua, name: String) -> LuaResult<()> {
    println!("hello, {}!", name);
    Ok(())
}

#[lua_module]
fn my_module(lua: &Lua) -> LuaResult<LuaTable> {
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
