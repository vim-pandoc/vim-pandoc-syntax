use pyo3::prelude::*;
use pyo3::wrap_pyfunction;

#[pyfunction]
fn to_html(_py: Python, buffer: String) -> PyResult<String> {
    Ok(super::to_html(buffer).unwrap())
}

#[pyfunction]
fn get_offsets(_py: Python, buffer: String) -> PyResult<()> {
    let events = super::get_offsets(buffer).unwrap();
    for event in events.iter() {
        eprintln!("DEBUG={:#?}", event);
    }
    Ok(())
}

#[pymodule]
fn libvim_pandoc_syntax(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_wrapped(wrap_pyfunction!(to_html))?;
    m.add_wrapped(wrap_pyfunction!(get_offsets))?;
    Ok(())
}
