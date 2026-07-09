" ==============================================================================
" ~/.vimrc
" ==============================================================================

" Yank straight to the Windows clipboard on WSL. Debian's vim ships with
" -clipboard, so "+y can't work — pipe the unnamed register to clip.exe
" instead. The executable() guard makes this a no-op on non-WSL machines,
" so the same file is safe on every box.
if executable('/mnt/c/Windows/System32/clip.exe')
  augroup WSLYank
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call system('/mnt/c/Windows/System32/clip.exe', @") | endif
  augroup END
endif
