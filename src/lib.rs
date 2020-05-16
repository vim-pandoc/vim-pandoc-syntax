#[cfg(feature = "lua")]
pub mod lua;

#[cfg(feature = "python")]
pub mod python;

use pulldown_cmark::{html, Event, Options, Parser, Tag};
use std::{error, result};

// #[cfg(feature = "lua")]
// type LibResult<T> = lua::LibResult<T>;

// #[cfg(feature = "python")]
// type LibResult<T> = python::LibResult<T>;

type Result<T> = result::Result<T, Box<dyn error::Error>>;

fn to_html(buffer: String) -> Result<String> {
    let options = Options::all();
    let parser = Parser::new_ext(buffer.as_str(), options);
    let mut html_output = String::new();
    html::push_html(&mut html_output, parser);
    Ok(html_output)
}

// fn get_event_offsets(&Lua, buffer: String) -> LibResult<LuaTable> {
//     let options = Options::all();
//     let parser = Parser::new_ext(buffer.as_str(), options);
//     let events = lua.create_table()?;
//     let mut i: u32 = 1;
//     for (event, range) in parser.into_offset_iter() {
//         if let Event::Start(tag) = event {
//             let group = match tag {
//                 Tag::Heading(n) => format!("cmarkHeading{}", n),
//                 _ => format!("cmark{:?}", tag),
//             };
//             let info = lua.create_table()?;
//             info.set("group", group)?;
//             info.set("first", range.start + 1)?;
//             info.set("length", range.end - range.start)?;
//             events.set(i, info)?;
//             i += 1;
//         }
//     }
//     Ok(events)
// }

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
