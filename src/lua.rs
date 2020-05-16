use mlua::prelude::*;
use mlua_derive::*;

fn to_html(_: &Lua, buffer: String) -> LuaResult<String> {
    Ok(super::to_html(buffer).unwrap())
}

#[lua_module]
fn libvim_pandoc_syntax(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("to_html", lua.create_function(to_html)?)?;
    // exports.set("get_event_offsets", lua.create_function(get_event_offsets)?)?;
    Ok(exports)
}
