use mlua::prelude::*;
use mlua_derive::*;

fn to_html(_: &Lua, buffer: String) -> LuaResult<String> {
    Ok(super::to_html(buffer).unwrap())
}

fn get_offsets(lua: &Lua, buffer: String) -> LuaResult<LuaTable> {
    let table = lua.create_table().unwrap();
    let events = super::get_offsets(buffer).unwrap();
    for (i, event) in events.iter().enumerate() {
        let info = lua.create_table().unwrap();
        info.set("group", event.group.as_str()).unwrap();
        info.set("first", event.first).unwrap();
        info.set("last", event.last).unwrap();
        table.set(i, info).unwrap();
    }
    Ok(table)
}

#[lua_module]
fn libvim_pandoc_syntax(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("to_html", lua.create_function(to_html)?)?;
    exports.set("get_offsets", lua.create_function(get_offsets)?)?;
    Ok(exports)
}
