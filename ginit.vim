" ----------------------------------------------------------------
" Config: NeoVim Graphical Interface Configuration
" ----------------------------------------------------------------

" ================================
" CONFIGURACOES GRAFICAS
" ================================
au VimEnter,VimResume * set guicursor=n-c:block,i-ci-ve:ver10,r-v:hor10
  \,a:blinkwait600-blinkoff600-blinkon600-Cursor/lCursor
au VimLeave,VimSuspend * set guicursor=
