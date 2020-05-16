#[macro_use]
extern crate mlua_derive;

use mlua::prelude::*;
use pulldown_cmark::{html, Event, Options, Parser, Tag};

fn render_html(_: &Lua, buffer: String) -> LuaResult<String> {
    let options = Options::all();
    let parser = Parser::new_ext(buffer.as_str(), options);
    let mut html_output = String::new();
    html::push_html(&mut html_output, parser);
    Ok(html_output)
}

fn get_event_offsets(lua: &Lua, buffer: String) -> LuaResult<LuaTable> {
    let options = Options::all();
    let parser = Parser::new_ext(buffer.as_str(), options);
    let events = lua.create_table()?;
    let mut i: u32 = 1;
    for (event, range) in parser.into_offset_iter() {
        if let Event::Start(tag) = event {
            let group = match tag {
                Tag::Heading(n) => format!("cmarkHeading{}", n),
                _ => format!("cmark{:?}", tag),
            };
            let info = lua.create_table()?;
            info.set("group", group)?;
            info.set("first", range.start + 1)?;
            info.set("length", range.end - range.start)?;
            events.set(i, info)?;
            i += 1;
        }
    }
    Ok(events)
}

#[lua_module]
fn libvim_pandoc_syntax(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("render_html", lua.create_function(render_html)?)?;
    exports.set("get_event_offsets", lua.create_function(get_event_offsets)?)?;
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
