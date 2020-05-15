#[macro_use]
extern crate mlua_derive;

use mlua::prelude::*;
use pulldown_cmark::{html, Event, Options, Parser};

fn render_html(_: &Lua, buffer: String) -> LuaResult<String> {
    let options = Options::all();
    let parser = Parser::new_ext(buffer.as_str(), options);
    let mut html_output = String::new();
    html::push_html(&mut html_output, parser);
    Ok(html_output)
}

fn get_offsets(lua: &Lua, buffer: String) -> LuaResult<LuaTable> {
    let options = Options::all();
    let parser = Parser::new_ext(buffer.as_str(), options);
    let starts = lua.create_table()?;
    let mut i: u32 = 1;
    for (event, range) in parser.into_offset_iter() {
        if let Event::Start(tag) = event {
            starts.set(i, format!("event at {:?} = {:#?}", range, tag))?;
            i += 1;
        }
    }
    Ok(starts)
}

#[lua_module]
fn libvim_pandoc_syntax(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("render_html", lua.create_function(render_html)?)?;
    exports.set("get_offsets", lua.create_function(get_offsets)?)?;
    Ok(exports)
}

#[cfg(test)]
mod tests {
    use crate::*;
    use mlua::Lua;

    #[test]
    fn can_render_html() {
        let ret = render_html(&Lua::new(), String::from("# thing")).unwrap();
        assert_eq!(ret, "<h1>thing</h1>\n");
    }
}
