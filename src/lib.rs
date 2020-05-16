#[cfg(feature = "lua")]
pub mod lua;

#[cfg(feature = "python")]
pub mod python;

use pulldown_cmark::{html, Event, Options, Parser, Tag};
use std::{error, result};

type Result<T> = result::Result<T, Box<dyn error::Error>>;

fn to_html(buffer: String) -> Result<String> {
    let options = Options::all();
    let parser = Parser::new_ext(buffer.as_str(), options);
    let mut html_output = String::new();
    html::push_html(&mut html_output, parser);
    Ok(html_output)
}

#[derive(Debug)]
struct MdTag {
    group: String,
    first: usize,
    last: usize,
}

type Events = Vec<MdTag>;

fn get_offsets(buffer: String) -> Result<Events> {
    let options = Options::all();
    let parser = Parser::new_ext(buffer.as_str(), options);
    let mut events = Events::new();
    for (event, range) in parser.into_offset_iter() {
        let first = range.start + 1;
        let last = range.end + 1;
        let group = match event {
            Event::Start(tag) => Some(match tag {
                Tag::Heading(level) => format!("cmarkHeading{}", level),
                Tag::CodeBlock(kind) => format!("cmarkCodeBlock{}", kind),
                Tag::Link { .. } => String::from("cmarkLink"),
                _ => format!("cmark{:?}", tag),
            }),
            Event::End { .. } => None,
            Event::Text { .. } => Some(String::from("cmarkText")),
            // Event::Code { .. } => {}
            // Event::Html { .. } => {}
            // Event::FootnoteReference { .. }=> {}
            Event::SoftBreak => None,
            // Event::HardBreak => {}
            Event::Rule => Some(String::from("cmarkRule")),
            // Event::TaskListMarker { .. }=> {}
            _other => Some(format!("cmark{:?}", _other)),
        };
        if let Some(group) = group {
            events.push(MdTag { group, first, last });
        }
    }
    Ok(events)
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
