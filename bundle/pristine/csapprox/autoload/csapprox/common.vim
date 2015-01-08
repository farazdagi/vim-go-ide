" Copyright (c) 2012, Matthew J. Wozniski
" All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
"     * Redistributions of source code must retain the above copyright
"       notice, this list of conditions and the following disclaimer.
"     * Redistributions in binary form must reproduce the above copyright
"       notice, this list of conditions and the following disclaimer in the
"       documentation and/or other materials provided with the distribution.
"     * The names of the contributors may not be used to endorse or promote
"       products derived from this software without specific prior written
"       permission.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY
" EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
" WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
" DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
" (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
" LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
" ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
" (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
" SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

" {>1} Handle terminal color cubes

let s:xterm_colors   = [ 0x00, 0x5F, 0x87, 0xAF, 0xD7, 0xFF ]
let s:eterm_colors   = [ 0x00, 0x2A, 0x55, 0x7F, 0xAA, 0xD4 ]
let s:konsole_colors = [ 0x00, 0x33, 0x66, 0x99, 0xCC, 0xFF ]
let s:xterm_greys    = [ 0x08, 0x12, 0x1C, 0x26, 0x30, 0x3A,
                       \ 0x44, 0x4E, 0x58, 0x62, 0x6C, 0x76,
                       \ 0x80, 0x8A, 0x94, 0x9E, 0xA8, 0xB2,
                       \ 0xBC, 0xC6, 0xD0, 0xDA, 0xE4, 0xEE ]

let s:urxvt_colors   = [ 0x00, 0x8B, 0xCD, 0xFF ]
let s:urxvt_greys    = [ 0x2E, 0x5C, 0x73, 0x8B,
                       \ 0xA2, 0xB9, 0xD0, 0xE7 ]

" Uses &term to determine which cube should be use.  If &term is set to
" "xterm" or begins with "screen", the variables g:CSApprox_eterm and
" g:CSApprox_konsole can be used to select a different palette.
function! csapprox#common#PaletteType()
  if &t_Co == 88
    let type = 'urxvt'
  elseif &term ==# 'xterm' || &term =~# '^screen' || &term==# 'builtin_gui'
    if exists('g:CSApprox_konsole') && g:CSApprox_konsole
      let type = 'konsole'
    elseif exists('g:CSApprox_eterm') && g:CSApprox_eterm
      let type = 'eterm'
    else
      let type = 'xterm'
    endif
  elseif &term =~? '^konsole'
    " Konsole only used its own palette up til KDE 4.2.0
    if executable('kde4-config') && system('kde4-config --kde-version') =~ '^4\.[10]\.'
      let type = 'konsole'
    elseif executable('kde-config') && system('kde-config --version') =~# 'KDE: 3\.'
      let type = 'konsole'
    else
      let type = 'xterm'
    endif
  elseif &term =~? '^eterm'
    let type = 'eterm'
  else
    let type = 'xterm'
  endif

  return type
endfunction

" Retrieve the list of greyscale ramp colors for the current palette
function! csapprox#common#Greys()
  return (&t_Co == 88 ? s:urxvt_greys : s:xterm_greys)
endfunction

" Retrieve the list of non-greyscale ramp colors for the current palette
function! csapprox#common#Colors()
  return s:{csapprox#common#PaletteType()}_colors
endfunction

" {>1} Handle color names

" Place to store rgb.txt name to color mappings - lazy loaded if needed
let s:rgb = {}

" {>2} Builtin gui color names
" gui_x11.c and gui_gtk_x11.c have some default colors names that are searched
" if the x server doesn't know about a color.  If 'showrgb' is available,
" we'll default to using these color names and values, and overwrite them with
" other values if 'showrgb' tells us about those colors.
let s:rgb_defaults = { "lightred"     : "#FFBBBB",
                     \ "lightgreen"   : "#88FF88",
                     \ "lightmagenta" : "#FFBBFF",
                     \ "darkcyan"     : "#008888",
                     \ "darkblue"     : "#0000BB",
                     \ "darkred"      : "#BB0000",
                     \ "darkmagenta"  : "#BB00BB",
                     \ "darkgrey"     : "#BBBBBB",
                     \ "darkyellow"   : "#BBBB00",
                     \ "gray10"       : "#1A1A1A",
                     \ "grey10"       : "#1A1A1A",
                     \ "gray20"       : "#333333",
                     \ "grey20"       : "#333333",
                     \ "gray30"       : "#4D4D4D",
                     \ "grey30"       : "#4D4D4D",
                     \ "gray40"       : "#666666",
                     \ "grey40"       : "#666666",
                     \ "gray50"       : "#7F7F7F",
                     \ "grey50"       : "#7F7F7F",
                     \ "gray60"       : "#999999",
                     \ "grey60"       : "#999999",
                     \ "gray70"       : "#B3B3B3",
                     \ "grey70"       : "#B3B3B3",
                     \ "gray80"       : "#CCCCCC",
                     \ "grey80"       : "#CCCCCC",
                     \ "gray90"       : "#E5E5E5",
                     \ "grey90"       : "#E5E5E5" }

" {>2} Colors that vim will use by name in one of the default schemes, either
" for bg=light or for bg=dark.  This lets us avoid loading the entire rgb.txt
" database when the scheme itself doesn't ask for colors by name.
let s:rgb_presets = { "black"         : "#000000",
                     \ "blue"         : "#0000ff",
                     \ "brown"        : "#a52a2a",
                     \ "cyan"         : "#00ffff",
                     \ "darkblue"     : "#00008b",
                     \ "darkcyan"     : "#008b8b",
                     \ "darkgrey"     : "#a9a9a9",
                     \ "darkmagenta"  : "#8b008b",
                     \ "green"        : "#00ff00",
                     \ "grey"         : "#bebebe",
                     \ "grey40"       : "#666666",
                     \ "grey90"       : "#e5e5e5",
                     \ "lightblue"    : "#add8e6",
                     \ "lightcyan"    : "#e0ffff",
                     \ "lightgrey"    : "#d3d3d3",
                     \ "lightmagenta" : "#ffbbff",
                     \ "magenta"      : "#ff00ff",
                     \ "red"          : "#ff0000",
                     \ "seagreen"     : "#2e8b57",
                     \ "white"        : "#ffffff",
                     \ "yellow"       : "#ffff00" }

" {>2} Find available color names
" Find the valid named colors.  By default, use our own rgb list, but try to
" retrieve the system's list if g:CSApprox_use_showrgb is set to true.  Store
" the color names and color values to the dictionary s:rgb - the keys are
" color names (in lowercase), the values are strings representing color values
" (as '#rrggbb').
function! s:UpdateRgbHash()
  try
    if !exists("g:CSApprox_use_showrgb") || !g:CSApprox_use_showrgb
      throw "Not using showrgb"
    endif

    " We want to use the 'showrgb' program, if it's around
    let lines = split(system('showrgb'), '\n')

    if v:shell_error || !exists('lines') || empty(lines)
      throw "'showrgb' didn't give us an rgb.txt"
    endif

    let s:rgb = copy(s:rgb_defaults)

    " fmt is (blanks?)(red)(blanks)(green)(blanks)(blue)(blanks)(name)
    let parsepat  = '^\s*\(\d\+\)\s\+\(\d\+\)\s\+\(\d\+\)\s\+\(.*\)$'

    for line in lines
      let v = matchlist(line, parsepat)
      if len(v) < 0
        throw "CSApprox: Bad RGB line: " . string(line)
      endif
      let s:rgb[tolower(v[4])] = printf("#%02x%02x%02x", v[1], v[2], v[3])
    endfor
  catch
    try
      let s:rgb = csapprox#rgb()
    catch
      echohl ErrorMsg
      echomsg "Can't call rgb() from autoload/csapprox.vim"
      echomsg "Named colors will not be available!"
      echohl None
    endtry
  endtry

  return 0
endfunction

" {>2} Resolve color names
" Given a color name, return the color as "#rrggbb".  Throws if the name
" cannot be resolved.
function! csapprox#common#color_name_to_hex(name)
  let val = tolower(a:name)

  try
    " First see if it is in our preset-by-vim rgb list
    let val = s:rgb_presets[val]
  catch
    " Then try loading and checking our real rgb list
    if empty(s:rgb)
      call s:UpdateRgbHash()
    endif
    let val = s:rgb[val] " Throws if the key can't be found
  endtry

  return val
endfunction

" {>2} Hex color to r, g, b
" Given a hex color string ("#rrggbb", with or without the leading '#'),
" return the a list containing the red, green, and blue components as ints.
function! csapprox#common#hex_to_rgb(hex)
  let val = substitute(a:hex, '^#', '', '')
  let r = str2nr(val[0:1], 16)
  let g = str2nr(val[2:3], 16)
  let b = str2nr(val[4:5], 16)
  return [r, g, b]
endfunction

" {0} vim:sw=2:sts=2:et:fdm=expr:fde=substitute(matchstr(getline(v\:lnum),'^\\s*"\\s*{\\zs.\\{-}\\ze}'),'^$','=','')
