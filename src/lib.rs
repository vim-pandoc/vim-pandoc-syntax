#[cfg(feature = "lua")]
pub mod lua;

#[cfg(feature = "python")]
pub mod python;

use pulldown_cmark::{html, CodeBlockKind, Event, Options, Parser, Tag};
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
    lang: Option<String>,
}

type Events = Vec<MdTag>;

fn get_offsets(buffer: String) -> Result<Events> {
    let options = Options::all();
    let parser = Parser::new_ext(buffer.as_str(), options);
    let mut events = Events::new();
    for (event, range) in parser.into_offset_iter() {
        let first = range.start + 1;
        let last = range.end + 1;
        let mut lang = None;
        let group = match event {
            Event::Start(tag) => Some(match tag {
                Tag::Heading(level) => format!("cmarkHeading{}", level),
                Tag::CodeBlock(kind) => match kind {
                    CodeBlockKind::Indented => String::from("cmarkCodeBlockIndented"),
                    CodeBlockKind::Fenced(attrs) => {
                        lang = Some(attrs.to_string());
                        String::from("cmarkCodeBlockFenced")
                    }
                },
                Tag::List(_) => String::from("cmarkList"),
                Tag::FootnoteDefinition(_) => String::from("cmarkFootnoteDefinition"),
                Tag::Table(_) => String::from("cmarkTable"),
                Tag::Link { .. } => String::from("cmarkLink"),
                Tag::Image { .. } => String::from("cmarkImage"),
                _ => format!("cmark{:?}", tag),
            }),
            Event::End { .. } => None,
            Event::Text { .. } => Some(String::from("cmarkText")),
            Event::Code { .. } => Some(String::from("cmarkCode")),
            Event::Html { .. } => Some(String::from("cmarkHtml")),
            Event::FootnoteReference { .. } => Some(String::from("cmarkFootnoteReference")),
            Event::SoftBreak => None,
            // Event::HardBreak => Some(String::from("cmarkHardBreak")),
            Event::Rule => Some(String::from("cmarkRule")),
            Event::TaskListMarker { .. } => Some(String::from("cmarkTaskListMarker")),
            _other => Some(format!("cmark{:?}", _other)),
        };
        if let Some(group) = group {
            events.push(MdTag {
                group,
                first,
                last,
                lang,
            });
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
