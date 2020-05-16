use pyo3::prelude::*;
use pyo3::wrap_pyfunction;
// use pyo3::{wrap_pyfunction, wrap_pymodule};

#[pyfunction]
fn to_html(_py: Python, buffer: String) -> PyResult<String> {
    Ok(super::to_html(buffer).unwrap())
}

#[pymodule]
fn libvim_pandoc_syntax(_py: Python, m: &PyModule) -> PyResult<()> {
    //     // m.add_wrapped(wrap_pymodule!(options))?;
    m.add_wrapped(wrap_pyfunction!(to_html))?;
    //     // m.add_wrapped(wrap_pyfunction!(get_offsets))?;
    Ok(())
}
