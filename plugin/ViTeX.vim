" ViTeX Comment Formatter
" Author: Josh Glendenning
" Version: 0.1

"=== Settings ========================================================

" Vars
let s:prompt_msg = 'Comment: '
let s:default_char = '-'
let s:default_box_char = s:default_char
let s:default_sec_char = s:default_char
let s:default_box_width = 50
let s:default_sec_width = 40

" Mappings
map! <Leader>block <C-R>=ViTeX_Block()<C-M>
map! <Leader>sec <C-R>=ViTeX_Sec()<C-M>

"======== Initialization ===========


function ViTeXInitBuffer()
    if !exists("b:ViTeXBufferInit")
        call s:set_c_vars(&ft)
        let b:ViTeXBufferInit = 1
        let b:box_char = s:default_box_char
        let b:box_width = s:default_box_width
        let b:sec_char = s:default_sec_char
        let b:sec_width = s:default_sec_width
    endif
endfunction

autocmd BufWinEnter,BufNewFile  *  call ViTeXInitBuffer()

"=== Helper Functions ===

function s:c(line, ...)
    " Backup formatoptions to return later and disable autocommenting
    let ops = &formatoptions
    setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    "

    " Ouput line
    let out = b:c_delim_open . a:line . b:c_delim_close
    if a:0 == 1
        return out
    else
        return out . "\r"
    end
    "

    " Return formatoptions
    let &formatoptions = ops
    "

endfunction

function s:prompt()
    return input(s:prompt_msg)
endfunction

"=== ViTeX Functions ==================================================

" Block
function! ViTeX_Block()
    let comment = s:prompt()
    let edge_space = b:box_width - (strlen(comment)+strlen(b:c_delim_open)+1)
    let insert =  s:c(repeat(b:box_char,b:box_width)).
                \ s:c(' '.comment.repeat(' ',edge_space).'|').
                \ s:c(repeat(b:box_char,b:box_width))
    return insert
endfunction

" Sec
function! ViTeX_Sec()
    let comment = s:prompt()
    let insert = s:c(repeat(b:sec_char,3).' '.comment.' '.repeat(b:sec_char,b:sec_width), 1)
    return insert
endfunction



"======================================================================


"GetFileTypeSettings, shamelessly copied  and modified from EnhancedCommentify
" Here's his license:


"Copyright (c) 2008 Meikel Brandmeyer, Frankfurt am Main
"All rights reserved.

"Redistribution and use in source and binary form are permitted provided
"that the following conditions are met:

"1. Redistribition of source code must retain the above copyright
   "notice, this list of conditions and the following disclaimer.

"2. Redistributions in binary form must reproduce the above copyright
   "notice, this list of conditions and the following disclaimer in the
   "documentation and/or other materials provided with the distribution.

"THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
"ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
"IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
"ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE
"FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
"DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
"OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
"HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
"LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
"OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
"SUCH DAMAGE.
"
function s:set_c_vars(ft)
    let fileType = a:ft

    " If we find nothing appropriate this is the default.
    let b:c_delim_open = ''
    let b:c_delim_close = ''

    " I learned about the commentstring option. Let's use it.
    " For now we ignore it, if it is "/*%s*/". This is the
    " default. We cannot check wether this is default or C or
    " something other like CSS, etc. We have to wait, until the
    " filetypes adopt this option.
    " Multipart comments:
    if fileType =~ '^\(c\|b\|css\|csc\|cupl\|indent\|jam\|lex\|lifelines\|'.
		\ 'lite\|nqc\|phtml\|progress\|rexx\|rpl\|sas\|sdl\|sl\|'.
		\ 'strace\|xpm\|yacc\)$'
	let b:c_delim_open = '/*'
	let b:c_delim_close = '*/'
    elseif fileType =~ '^\(html\|xhtml\|xml\|xslt\|xsd\|dtd\|sgmllnx\)$'
	let b:c_delim_open = '<!--'
	let b:c_delim_close = '-->'
    elseif fileType =~ '^\(sgml\|smil\)$'
	let b:c_delim_open = '<!'
	let b:c_delim_close = '>'
    elseif fileType == 'atlas'
	let b:c_delim_open = 'C'
	let b:c_delim_close = '$'
    elseif fileType =~ '^\(catalog\|sgmldecl\)$'
	let b:c_delim_open = '--'
	let b:c_delim_close = '--'
    elseif fileType == 'dtml'
	let b:c_delim_open = '<dtml-comment>'
	let b:c_delim_close = '</dtml-comment>'
    elseif fileType == 'htmlos'
	let b:c_delim_open = '#'
	let b:c_delim_close = '/#'
    elseif fileType =~ '^\(jgraph\|lotos\|mma\|modula2\|modula3\|pascal\|'.
		\ 'ocaml\|sml\)$'
	let b:c_delim_open = '(*'
	let b:c_delim_close = '*)'
    elseif fileType == 'jsp'
	let b:c_delim_open = '<%--'
	let b:c_delim_close = '--%>'
    elseif fileType == 'model'
	let b:c_delim_open = '$'
	let b:c_delim_close = '$'
    elseif fileType == 'st'
	let b:c_delim_open = '"'
	let b:c_delim_close = '"'
    elseif fileType =~ '^\(tssgm\|tssop\)$'
	let b:c_delim_open = 'comment = "'
	let b:c_delim_close = '"'
    " Singlepart comments:
    elseif fileType =~ '^\(ox\|cpp\|php\|java\|verilog\|acedb\|ch\|clean\|'.
		\ 'clipper\|cs\|dot\|dylan\|hercules\|idl\|ishd\|javascript\|'.
		\ 'kscript\|mel\|named\|openroad\|pccts\|pfmain\|pike\|'.
		\ 'pilrc\|plm\|pov\|rc\|scilab\|specman\|tads\|tsalt\|uc\|'.
		\ 'xkb\)$'
	let b:c_delim_open = '//'
	let b:c_delim_close = ''
    elseif fileType =~ '^\(vim\|abel\)$'
	let b:c_delim_open = '"'
	let b:c_delim_close = ''
    elseif fileType =~ '^\(lisp\|scheme\|scsh\|amiga\|asm\|asm68k\|bindzone\|'.
		\ 'def\|dns\|dosini\|dracula\|dsl\|idlang\|iss\|jess\|kix\|'.
		\ 'masm\|monk\|nasm\|ncf\|omnimark\|pic\|povini\|rebol\|'.
		\ 'registry\|samba\|skill\|smith\|tags\|tasm\|tf\|winbatch\|'.
		\ 'wvdial\|z8a\)$'
	let b:c_delim_open = ';'
	let b:c_delim_close = ''
    elseif fileType =~ '^\(python\|perl\|[^w]*sh$\|tcl\|jproperties\|make\|'.
		\ 'robots\|apache\|apachestyle\|awk\|bc\|cfg\|cl\|conf\|'.
		\ 'crontab\|diff\|ecd\|elmfilt\|eterm\|expect\|exports\|'.
		\ 'fgl\|fvwm\|gdb\|gnuplot\|gtkrc\|hb\|hog\|ia64\|icon\|'.
		\ 'inittab\|lftp\|lilo\|lout\|lss\|lynx\|maple\|mush\|'.
		\ 'muttrc\|nsis\|ora\|pcap\|pine\|po\|procmail\|'.
		\ 'psf\|ptcap\|r\|radiance\|ratpoison\|readline\remind\|'.
		\ 'ruby\|screen\|sed\|sm\|snnsnet\|snnspat\|snnsres\|spec\|'.
		\ 'squid\|terminfo\|tidy\|tli\|tsscl\|vgrindefs\|vrml\|'.
		\ 'wget\|wml\|xf86conf\|xmath\)$'
	let b:c_delim_open = '#'
	let b:c_delim_close = ''
    elseif fileType == 'webmacro'
	let b:c_delim_open = '##'
	let b:c_delim_close = ''
    elseif fileType == 'ppwiz'
	let b:c_delim_open = ';;'
	let b:c_delim_close = ''
    elseif fileType == 'latte'
	let b:c_delim_open = '\\;'
	let b:c_delim_close = ''
    elseif fileType =~ '^\(tex\|abc\|erlang\|ist\|lprolog\|matlab\|mf\|'.
		\ 'postscr\|ppd\|prolog\|simula\|slang\|slrnrc\|slrnsc\|'.
		\ 'texmf\|viki\|virata\)$'
	let b:c_delim_open = '%'
	let b:c_delim_close = ''
    elseif fileType =~ '^\(caos\|cterm\|form\|foxpro\|sicad\|snobol4\)$'
	let b:c_delim_open = '*'
	let b:c_delim_close = ''
    elseif fileType =~ '^\(m4\|config\|automake\)$'
	let b:c_delim_open = 'dnl '
	let b:c_delim_close = ''
    elseif fileType =~ '^\(vb\|aspvbs\|ave\|basic\|elf\|lscript\)$'
	let b:c_delim_open = "'"
	let b:c_delim_close = ''
    elseif fileType =~ '^\(plsql\|vhdl\|ahdl\|ada\|asn\|csp\|eiffel\|gdmo\|'.
		\ 'haskell\|lace\|lua\|mib\|sather\|sql\|sqlforms\|sqlj\|'.
		\ 'stp\)$'
	let b:c_delim_open = '--'
	let b:c_delim_close = ''
    elseif fileType == 'abaqus'
	let b:c_delim_open = '**'
	let b:c_delim_close = ''
    elseif fileType =~ '^\(aml\|natural\|vsejcl\)$'
	let b:c_delim_open = '/*'
	let b:c_delim_close = ''
    elseif fileType == 'ampl'
	let b:c_delim_open = '\\#'
	let b:c_delim_close = ''
    elseif fileType == 'bdf'
	let b:c_delim_open = 'COMMENT '
	let b:c_delim_close = ''
    elseif fileType == 'btm'
	let b:c_delim_open = '::'
	let b:c_delim_close = ''
    elseif fileType == 'dcl'
	let b:c_delim_open = '$!'
	let b:c_delim_close = ''
    elseif fileType == 'dosbatch'
	let b:c_delim_open = 'rem '
	let b:c_delim_close = ''
    elseif fileType == 'focexec'
	let b:c_delim_open = '-*'
	let b:c_delim_close = ''
    elseif fileType == 'forth'
	let b:c_delim_open = '\\ '
	let b:c_delim_close = ''
    elseif fileType =~ '^\(fortran\|inform\|sqr\|uil\|xdefaults\|'.
		\ 'xmodmap\|xpm2\)$'
	let b:c_delim_open = '!'
	let b:c_delim_close = ''
    elseif fileType == 'gp'
	let b:c_delim_open = '\\\\'
	let b:c_delim_close = ''
    elseif fileType =~ '^\(master\|nastran\|sinda\|spice\|tak\|trasys\)$'
	let b:c_delim_open = '$'
	let b:c_delim_close = ''
    elseif fileType == 'nroff' || fileType == 'groff'
	let b:c_delim_open = ".\\\\\""
	let b:c_delim_close = ''
    elseif fileType == 'opl'
	let b:c_delim_open = 'REM '
	let b:c_delim_close = ''
    elseif fileType == 'texinfo'
	let b:c_delim_open = '@c '
	let b:c_delim_close = ''
    elseif fileType == 'mail'
	let b:c_delim_open = '>'
	let b:c_delim_close = ''
    endif

endfunction

