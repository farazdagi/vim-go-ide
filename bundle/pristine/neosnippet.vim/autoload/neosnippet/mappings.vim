"=============================================================================
" FILE: mappings.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! neosnippet#mappings#expandable_or_jumpable() abort
  return neosnippet#mappings#expandable() || neosnippet#mappings#jumpable()
endfunction
function! neosnippet#mappings#expandable() abort
  " Check snippet trigger.
  return neosnippet#mappings#completed_expandable()
        \ || neosnippet#helpers#get_cursor_snippet(
        \      neosnippet#helpers#get_snippets('i'),
        \      neosnippet#util#get_cur_text()) != ''
endfunction
function! neosnippet#mappings#jumpable() abort
  " Found snippet placeholder.
  return search(neosnippet#get_placeholder_marker_pattern(). '\|'
            \ .neosnippet#get_sync_placeholder_marker_pattern(), 'nw') > 0
endfunction
function! neosnippet#mappings#completed_expandable() abort
  if !s:enabled_completed_snippet()
    return 0
  endif

  let snippet = neosnippet#parser#_get_completed_snippet(
        \ v:completed_item, neosnippet#util#get_cur_text(),
        \ neosnippet#util#get_next_text())
  return snippet != ''
endfunction
function! s:enabled_completed_snippet() abort
  return exists('v:completed_item')
        \ && !empty(v:completed_item)
        \ && g:neosnippet#enable_completed_snippet
endfunction

function! neosnippet#mappings#_clear_select_mode_mappings() abort
  if !g:neosnippet#disable_select_mode_mappings
    return
  endif

  redir => mappings
    silent! smap
  redir END

  for map in map(filter(split(mappings, '\n'),
        \ "v:val !~# '^s' && v:val !~ '^\\a*\\s*<\\S\\+>'"),
        \ "matchstr(v:val, '^\\a*\\s*\\zs\\S\\+')")
    silent! execute 'sunmap' map
    silent! execute 'sunmap <buffer>' map
  endfor

  " Define default select mode mappings.
  snoremap <CR>     a<BS>
  snoremap <BS>     a<BS>
  snoremap <Del>    a<BS>
  snoremap <C-h>    a<BS>
endfunction

function! neosnippet#mappings#_register_oneshot_snippet() abort
  let trigger = input('Please input snippet trigger: ', 'oneshot')
  if trigger == ''
    return
  endif

  let selected_text = substitute(
        \ neosnippet#helpers#get_selected_text(visualmode(), 1), '\n$', '', '')
  call neosnippet#helpers#delete_selected_text(visualmode(), 1)

  let base_indent = matchstr(selected_text, '^\s*')

  " Delete base_indent.
  let selected_text = substitute(selected_text,
        \'^' . base_indent, '', 'g')

  let neosnippet = neosnippet#variables#current_neosnippet()
  let options = neosnippet#parser#_initialize_snippet_options()
  let options.word = 1
  let options.oneshot = 1

  let neosnippet.snippets[trigger] = neosnippet#parser#_initialize_snippet(
        \ { 'name' : trigger, 'word' : selected_text, 'options' : options },
        \ '', 0, '', trigger)

  echo 'Registered trigger : ' . trigger
endfunction

function! neosnippet#mappings#_expand_target() abort
  let trigger = input('Please input snippet trigger: ',
        \ '', 'customlist,neosnippet#commands#_complete_target_snippets')
  let neosnippet = neosnippet#variables#current_neosnippet()
  if !has_key(neosnippet#helpers#get_snippets('i'), trigger) ||
        \ neosnippet#helpers#get_snippets('i')[trigger].snip !~#
        \   neosnippet#get_placeholder_target_marker_pattern()
    if trigger != ''
      echo 'The trigger is invalid.'
    endif

    let neosnippet.target = ''
    return
  endif

  call neosnippet#mappings#_expand_target_trigger(trigger)
endfunction
function! neosnippet#mappings#_expand_target_trigger(trigger) abort
  let neosnippet = neosnippet#variables#current_neosnippet()
  let neosnippet.target = substitute(
        \ neosnippet#helpers#get_selected_text(visualmode(), 1), '\n$', '', '')

  let line = getpos("'<")[1]
  let col = getpos("'<")[2]

  call neosnippet#helpers#delete_selected_text(visualmode())

  call cursor(line, col)

  if col == 1
    let cur_text = a:trigger
  else
    let cur_text = neosnippet#util#get_cur_text()
    let cur_text = cur_text[: col-2] . a:trigger . cur_text[col :]
  endif

  call neosnippet#view#_expand(cur_text, col, a:trigger)

  if !neosnippet#mappings#jumpable()
    call cursor(0, col('.') - 1)
    stopinsert
  endif
endfunction

function! neosnippet#mappings#_anonymous(snippet) abort
  let [cur_text, col, expr] = neosnippet#mappings#_pre_trigger()
  let expr .= printf("\<ESC>:call neosnippet#view#_insert(%s, {}, %s, %d)\<CR>",
        \ string(a:snippet), string(cur_text), col)

  return expr
endfunction
function! neosnippet#mappings#_expand(trigger) abort
  let [cur_text, col, expr] = neosnippet#mappings#_pre_trigger()

  let expr .= printf("\<ESC>:call neosnippet#view#_expand(%s, %d, %s)\<CR>",
        \ string(cur_text), col, string(a:trigger))

  return expr
endfunction

function! s:snippets_expand(cur_text, col) abort
  if s:expand_completed_snippets(a:cur_text, a:col)
    return 0
  endif

  let cur_word = neosnippet#helpers#get_cursor_snippet(
        \ neosnippet#helpers#get_snippets('i'),
        \ a:cur_text)
  if cur_word != ''
    " Found snippet trigger.
    call neosnippet#view#_expand(
          \ neosnippet#util#get_cur_text(), a:col, cur_word)
    return 0
  endif

  return 1
endfunction
function! s:expand_completed_snippets(cur_text, col) abort
  if !s:enabled_completed_snippet()
    return 0
  endif

  let cur_text = a:cur_text

  if !empty(get(g:, 'deoplete#_context', []))
        \ && has_key(v:completed_item, 'word')
    let completed_candidates = filter(copy(g:deoplete#_context),
          \ "has_key(v:val, 'snippet') && has_key(v:val, 'snippet_trigger')
          \  && v:val.word ==# v:completed_item.word")
    if !empty(completed_candidates)
      let v:completed_item.snippet = completed_candidates[0].snippet
      let v:completed_item.snippet_trigger =
            \ completed_candidates[0].snippet_trigger
    endif
  endif

  let snippet = neosnippet#parser#_get_completed_snippet(
        \ v:completed_item, cur_text, neosnippet#util#get_next_text())
  if snippet == ''
    return 0
  endif

  if has_key(v:completed_item, 'snippet_trigger')
    let cur_text = cur_text[: -1-len(v:completed_item.snippet_trigger)]
  endif

  call neosnippet#view#_insert(snippet, {}, cur_text, a:col)
  return 1
endfunction

function! s:snippets_expand_or_jump(cur_text, col) abort
  if s:snippets_expand(a:cur_text, a:col)
    call neosnippet#view#_jump('', a:col)
  endif
endfunction

function! s:snippets_jump_or_expand(cur_text, col) abort
  if search(neosnippet#get_placeholder_marker_pattern(). '\|'
            \ .neosnippet#get_sync_placeholder_marker_pattern(), 'nw') > 0
    " Found snippet placeholder.
    call neosnippet#view#_jump('', a:col)
  else
    return s:snippets_expand(a:cur_text, a:col)
  endif
endfunction

function! s:SID_PREFIX() abort
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\ze\w\+$')
endfunction

function! neosnippet#mappings#_trigger(function) abort
  let [cur_text, col, expr] = neosnippet#mappings#_pre_trigger()

  if !neosnippet#mappings#expandable_or_jumpable()
    return ''
  endif

  let expr .= printf("\<ESC>:call %s(%s,%d)\<CR>",
        \ a:function, string(cur_text), col)

  return expr
endfunction

function! neosnippet#mappings#_pre_trigger() abort
  call neosnippet#init#check()

  let cur_text = neosnippet#util#get_cur_text()

  let col = col('.')
  let expr = ''
  if mode() !=# 'i'
    " Fix column.
    let col += 2
  endif

  " Get selected text.
  let neosnippet = neosnippet#variables#current_neosnippet()
  let neosnippet.trigger = 1
  if mode() ==# 's' && neosnippet.optional_tabstop
    let expr .= "\<C-o>\"_d"
  endif

  return [cur_text, col, expr]
endfunction

" Plugin key-mappings.
function! neosnippet#mappings#expand_or_jump_impl() abort
  return mode() ==# 's' ?
        \ neosnippet#mappings#_trigger('neosnippet#view#_jump') :
        \ neosnippet#mappings#_trigger(
        \   s:SID_PREFIX().'snippets_expand_or_jump')
endfunction
function! neosnippet#mappings#jump_or_expand_impl() abort
  return mode() ==# 's' ?
        \ neosnippet#mappings#_trigger('neosnippet#view#_jump') :
        \ neosnippet#mappings#_trigger(
        \   s:SID_PREFIX().'snippets_jump_or_expand')
endfunction
function! neosnippet#mappings#expand_impl() abort
  return neosnippet#mappings#_trigger(s:SID_PREFIX().'snippets_expand')
endfunction
function! neosnippet#mappings#jump_impl() abort
  return neosnippet#mappings#_trigger('neosnippet#view#_jump')
endfunction
