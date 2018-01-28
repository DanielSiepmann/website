"============================================================================
"File:        typo3-typoscript-lint.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Daniel Siepmann <coding at daniel-siepmann dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Daniel
"             Siepmann.
"============================================================================

if exists('g:loaded_syntastic_typoscript_lint_checker')
    finish
endif
let g:loaded_syntastic_typoscript_lint_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_typoscript_lint_GetLocList() dict
    let makeprg = self.makeprgBuild({
        \ "exe": self.getExec(),
        \ "args": '--format=checkstyle',
        \ })

    let errorformat = '%f:%t:%l:%c:%m'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'preprocess': 'checkstyle',
        \ 'postprocess': ['guards'] })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'typoscript',
    \ 'name': 'lint'})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et
