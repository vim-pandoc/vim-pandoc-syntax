" vim: set fdm=marker :
"
" file: autoload/pandoc/syntax/color.vim
" author: Felipe Morales
" version: 0.1
" description: functions to manipulate color

" Conversion: {{{1
"
" color conversion algorithms adapted from http://www.cs.rit.edu/~ncs/color/t_convert.html

function! s:RGB2HSV(r, g, b) "{{{2
    let rp = a:r/255.0
    let gp = a:g/255.0
    let bp = a:b/255.0
    let cmax = max([float2nr(rp*100.0), float2nr(gp*100.0), float2nr(bp*100.0)])/100.0
    let cmin = min([float2nr(rp*100.0), float2nr(gp*100.0), float2nr(bp*100.0)])/100.0
    let delta = cmax - cmin
    let v = cmax
    if cmax == 0.0
        let s = 0.0
        let h = -1.0
    else
        let s = delta/cmax
        if rp == cmax
            let h = (gp - bp)/ delta
        elseif gp == cmax
            let h = (2.0 + (bp - rp))/delta
        else
            let h = (4.0 + (rp - gp))/delta
        endif
        let h = h * 60.0
        if h < 0.0
            let h = h+ 360.0
        endif
    endif
    return [h, s, v]
endfunction

function! s:HSV2RGB(h, s, v) "{{{2
    if a:s == 0 "achromatic
        return [a:v, a:v, a:v]
    endif
    let h = a:h/60 " sector 0 to 5
    let i = floor(h)
    let f = h - i
    let p = a:v * ( 1 - a:s)
    let q = a:v * ( 1 - a:s * f)
    let t = a:v * ( 1 - a:s * (1 - f))

    if i == 0
        let r = a:v
        let g = t
        let b = p
    elseif i == 1
        let r = q
        let g = a:v
        let b = p
    elseif i == 2
        let r = p
        let g = a:v
        let b = t
    elseif i == 3
        let r = p
        let g = q
        let b = a:v
    elseif i == 4
        let r = t
        let g = p
        let b = a:v
    else
        let r = a:v
        let g = p
        let b = q
    endif
    return [float2nr(r*255), float2nr(g*255), float2nr(b*255)]
endfunction

function! s:Hex2RGB(hex) "{{{2
    let hex = split(a:hex, '\zs')
    let h_r = '0x'.join(hex[:1], '')
    let h_g = '0x'.join(hex[2:3], '')
    let h_b = '0x'.join(hex[4:6], '')
    return map([h_r, h_g, h_b], 'eval(v:val)')
endfunction

function! s:RGB2Hex(r, g, b) "{{{2
    let h_r = printf("%02x", a:r)
    let h_g = printf("%02x", a:g)
    let h_b = printf("%02x", a:b)
    return join([h_r, h_g, h_b], '')
endfunction

" Instrospection: {{{1

function! pandoc#syntax#color#Instrospect(group)
    redir => hi_output
    exe 'silent hi '. a:group
    redir END
    let hi_output = split(hi_output, '\n')[0]
    let parts = split(hi_output, '\s\+')[2:]
    if parts[0] == 'links'
        let info = Hi_Info(parts[2])
        let info['linked_to'] = parts[2]
    else
        let info = {}
        for i in parts
            let data = split(i, "=")
            let info[data[0]] = data[1]
        endfor
    endif
    return info
endfunction

" Palette: {{{1

function! pandoc#syntax#color#SaturationPalette(hex, partitions)
    let rgb = s:Hex2RGB(a:hex)
    let hsv = s:RGB2HSV(rgb[0], rgb[1], rgb[2])
    let hsv_palette = []
    for i in range(1, a:partitions)
        let s = 1.0/a:partitions * i " linear
        call add(hsv_palette, [hsv[0], s, hsv[2]])
    endfor
    let rgb_palette = []
    for hsv in hsv_palette
        call add(rgb_palette, s:HSV2RGB(hsv[0], hsv[1], hsv[2]))
    endfor
    let hex_palette = []
    for rgb in rgb_palette 
        call add(hex_palette, s:RGB2Hex(rgb[0], rgb[1], rgb[2]))
    endfor
    return hex_palette
endfunction
