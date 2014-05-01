" Vim syntax file
" Language: ANTLR4
" Maintainer: Adam Blinkinsop <blinks@acm.org>
" Last Change: 2014 May 1
" Remark: Piggy-backs on Java syntax.

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

runtime! "syntax/java.vim"
