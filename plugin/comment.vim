autocmd BufRead,BufEnter * :call s:SetUpForNewFiletype(&filetype)

nnoremap <localleader>mm :call <SID>CommentOperator(1)<cr>
nnoremap <localleader>m :set operatorfunc=<SID>Comment<cr>g@
vnoremap <localleader>m :<c-u>call <SID>Comment(visualmode())<cr>

let s:specialcharacters = '/*'

function! s:Comment(type)
  let range = s:GetRange(a:type)
  let saved_cursor = getcurpos()
  execute range.'call s:CommentOperator(0)'
  noh
  call setpos('.', saved_cursor)
endfunction

function! s:getIndentation(line)
  let match = match(getline(a:line),'\S')
  return match
endfunction

function! s:isLineCommented(line)
  let match = search('\%'.a:line.'l^\s*'.escape(b:left, s:specialcharacters)
        \.'.*'.escape(b:right, s:specialcharacters).'$')
  return match
endfunction

function! s:unComment()
  execute 's/^\s*\zs'.escape(b:left, s:specialcharacters).'\%(\[\(\d\)\]\)\?'.'\(\s\{0,'.len(b:left).'\}\)'.'\(.*\)'.escape(b:right, s:specialcharacters).'$/\=repeat(" ", submatch(1)).submatch(2).submatch(2).submatch(3)/'
endfunction

function! s:doComment(indent)
  let lineIndent = s:getIndentation('.')
  let indentIndicator = ''
  if lineIndent < len(b:left) && lineIndent != 0 && lineIndent != -1
    let indentIndicator = '['.lineIndent.']'
  endif

  if !a:indent
    " Insert comment at the beginning of the line.
    execute 's/\(^\s\{0,'.len(b:left).'\}\)\(.*$\)/'.escape(b:left, s:specialcharacters).indentIndicator.'\2'.escape(b:right, s:specialcharacters).'/'
  else
    " Insert comment at indentation.
    execute 's/^\(\s*\)\(.*$\)/\1'.escape(b:left, s:specialcharacters).'\2'.escape(b:right, s:specialcharacters).'/'
  endif
endfunction

function! s:CommentOperator(indent)
  let curline = saved_cursor[1]
  " If the current line is commented uncomment the whole block.
  " Otherwise comment the whole block.
  if s:isLineCommented(curline)
    call s:unComment()
  else
    call s:doComment(a:indent)
  endif
endfunction

function! s:GetRange(type)
  if a:type ==# 'char' || a:type ==# 'line'
    return '''[,'']'
  elseif a:type ==# 'v' || a:type ==# 'V' || a:type ==# "\<c-v>"
    return '''<,''>'
  else
    return ','.line('.')
  endif
endfunction

" Delimiter map taken from 'NERD_commenter.vim'

let s:delimiterMap = {
      \ 'aap': { 'left': '#' },
      \ 'abc': { 'left': '%' },
      \ 'acedb': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'actionscript': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'ada': { 'left': '--', 'leftAlt': '--  ' },
      \ 'ahdl': { 'left': '--' },
      \ 'ahk': { 'left': ';', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'amiga': { 'left': ';' },
      \ 'aml': { 'left': '/*' },
      \ 'ampl': { 'left': '#' },
      \ 'apache': { 'left': '#' },
      \ 'apachestyle': { 'left': '#' },
      \ 'asciidoc': { 'left': '//' },
      \ 'applescript': { 'left': '--', 'leftAlt': '(*', 'rightAlt': '*)' },
      \ 'asm68k': { 'left': ';' },
      \ 'asm': { 'left': ';', 'leftAlt': '#' },
      \ 'asn': { 'left': '--' },
      \ 'aspvbs': { 'left': '''' },
      \ 'asterisk': { 'left': ';' },
      \ 'asy': { 'left': '//' },
      \ 'atlas': { 'left': 'C', 'right': '$' },
      \ 'autohotkey': { 'left': ';' },
      \ 'autoit': { 'left': ';' },
      \ 'ave': { 'left': "'" },
      \ 'awk': { 'left': '#' },
      \ 'basic': { 'left': "'", 'leftAlt': 'REM ' },
      \ 'bbx': { 'left': '%' },
      \ 'bc': { 'left': '#' },
      \ 'bib': { 'left': '%' },
      \ 'bindzone': { 'left': ';' },
      \ 'bst': { 'left': '%' },
      \ 'btm': { 'left': '::' },
      \ 'caos': { 'left': '*' },
      \ 'calibre': { 'left': '//' },
      \ 'catalog': { 'left': '--', 'right': '--' },
      \ 'c': { 'left': '/*','right': '*/', 'leftAlt': '//' },
      \ 'cfg': { 'left': '#' },
      \ 'cg': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'ch': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'cl': { 'left': '#' },
      \ 'clean': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'clipper': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'clojure': { 'left': ';' },
      \ 'cmake': { 'left': '#' },
      \ 'conkyrc': { 'left': '#' },
      \ 'cpp': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'crontab': { 'left': '#' },
      \ 'cs': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'csp': { 'left': '--' },
      \ 'cterm': { 'left': '*' },
      \ 'cucumber': { 'left': '#' },
      \ 'cvs': { 'left': 'CVS:' },
      \ 'd': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'dcl': { 'left': '$!' },
      \ 'dakota': { 'left': '#' },
      \ 'debcontrol': { 'left': '#' },
      \ 'debsources': { 'left': '#' },
      \ 'def': { 'left': ';' },
      \ 'desktop': { 'left': '#' },
      \ 'dhcpd': { 'left': '#' },
      \ 'diff': { 'left': '#' },
      \ 'django': { 'left': '<!--','right': '-->', 'leftAlt': '{#', 'rightAlt': '#}' },
      \ 'docbk': { 'left': '<!--', 'right': '-->' },
      \ 'dns': { 'left': ';' },
      \ 'dosbatch': { 'left': 'REM ', 'leftAlt': '::' },
      \ 'dosini': { 'left': ';' },
      \ 'dot': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'dracula': { 'left': ';' },
      \ 'dsl': { 'left': ';' },
      \ 'dtml': { 'left': '<dtml-comment>', 'right': '</dtml-comment>' },
      \ 'dylan': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'ebuild': { 'left': '#' },
      \ 'ecd': { 'left': '#' },
      \ 'eclass': { 'left': '#' },
      \ 'eiffel': { 'left': '--' },
      \ 'elf': { 'left': "'" },
      \ 'elmfilt': { 'left': '#' },
      \ 'erlang': { 'LEFT': '%' },
      \ 'eruby': { 'left': '<%#', 'right': '%>', 'leftAlt': '<!--', 'rightAlt': '-->' },
      \ 'expect': { 'left': '#' },
      \ 'exports': { 'left': '#' },
      \ 'factor': { 'left': '! ', 'leftAlt': '!# ' },
      \ 'fgl': { 'left': '#' },
      \ 'focexec': { 'left': '-*' },
      \ 'form': { 'left': '*' },
      \ 'foxpro': { 'left': '*' },
      \ 'fstab': { 'left': '#' },
      \ 'fvwm': { 'left': '#' },
      \ 'fx': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'gams': { 'left': '*' },
      \ 'gdb': { 'left': '#' },
      \ 'gdmo': { 'left': '--' },
      \ 'geek': { 'left': 'GEEK_COMMENT:' },
      \ 'genshi': { 'left': '<!--','right': '-->', 'leftAlt': '{#', 'rightAlt': '#}' },
      \ 'gentoo-conf-d': { 'left': '#' },
      \ 'gentoo-env-d': { 'left': '#' },
      \ 'gentoo-init-d': { 'left': '#' },
      \ 'gentoo-make-conf': { 'left': '#' },
      \ 'gentoo-package-keywords': { 'left': '#' },
      \ 'gentoo-package-mask': { 'left': '#' },
      \ 'gentoo-package-use': { 'left': '#' },
      \ 'gitcommit': { 'left': '#' },
      \ 'gitconfig': { 'left': ';' },
      \ 'gitrebase': { 'left': '#' },
      \ 'gnuplot': { 'left': '#' },
      \ 'groovy': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'gsp': { 'left': '<%--', 'right': '--%>' },
      \ 'gtkrc': { 'left': '#' },
      \ 'haskell': { 'left': '{-','right': '-}', 'leftAlt': '--' },
      \ 'hb': { 'left': '#' },
      \ 'h': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'haml': { 'left': '-#', 'leftAlt': '/' },
      \ 'hercules': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'hog': { 'left': '#' },
      \ 'hostsaccess': { 'left': '#' },
      \ 'html': { 'left': '<!--', 'right': '-->' },
      \ 'ia64': { 'left': '#' },
      \ 'icon': { 'left': '#' },
      \ 'idlang': { 'left': ';' },
      \ 'idl': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'inform': { 'left': '!' },
      \ 'inittab': { 'left': '#' },
      \ 'ishd': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'iss': { 'left': ';' },
      \ 'ist': { 'left': '%' },
      \ 'java': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'javacc': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'javascript': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'javascript.jquery': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'jess': { 'left': ';' },
      \ 'jgraph': { 'left': '(*', 'right': '*)' },
      \ 'jproperties': { 'left': '#' },
      \ 'jsp': { 'left': '<%--', 'right': '--%>' },
      \ 'kix': { 'left': ';' },
      \ 'kscript': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'lace': { 'left': '--' },
      \ 'ldif': { 'left': '#' },
      \ 'lilo': { 'left': '#' },
      \ 'lilypond': { 'left': '%' },
      \ 'liquid': { 'left': '{%', 'right': '%}' },
      \ 'lisp': { 'left': ';', 'leftAlt': '#|', 'rightAlt': '|#' },
      \ 'llvm': { 'left': ';' },
      \ 'lotos': { 'left': '(*', 'right': '*)' },
      \ 'lout': { 'left': '#' },
      \ 'lprolog': { 'left': '%' },
      \ 'lscript': { 'left': "'" },
      \ 'lss': { 'left': '#' },
      \ 'lua': { 'left': '--', 'leftAlt': '--[[', 'rightAlt': ']]' },
      \ 'lynx': { 'left': '#' },
      \ 'lytex': { 'left': '%' },
      \ 'mail': { 'left': '> ' },
      \ 'mako': { 'left': '##' },
      \ 'man': { 'left': '."' },
      \ 'map': { 'left': '%' },
      \ 'maple': { 'left': '#' },
      \ 'markdown': { 'left': '<!--', 'right': '-->' },
      \ 'masm': { 'left': ';' },
      \ 'mason': { 'left': '<% #', 'right': '%>' },
      \ 'master': { 'left': '$' },
      \ 'matlab': { 'left': '%' },
      \ 'mel': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'mib': { 'left': '--' },
      \ 'mkd': { 'left': '>' },
      \ 'mma': { 'left': '(*', 'right': '*)' },
      \ 'model': { 'left': '$', 'right': '$' },
      \ 'moduala.': { 'left': '(*', 'right': '*)' },
      \ 'modula2': { 'left': '(*', 'right': '*)' },
      \ 'modula3': { 'left': '(*', 'right': '*)' },
      \ 'monk': { 'left': ';' },
      \ 'mush': { 'left': '#' },
      \ 'named': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'nasm': { 'left': ';' },
      \ 'nastran': { 'left': '$' },
      \ 'natural': { 'left': '/*' },
      \ 'ncf': { 'left': ';' },
      \ 'newlisp': { 'left': ';' },
      \ 'nroff': { 'left': '\"' },
      \ 'nsis': { 'left': '#' },
      \ 'ntp': { 'left': '#' },
      \ 'objc': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'objcpp': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'objj': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'ocaml': { 'left': '(*', 'right': '*)' },
      \ 'occam': { 'left': '--' },
      \ 'omlet': { 'left': '(*', 'right': '*)' },
      \ 'omnimark': { 'left': ';' },
      \ 'openroad': { 'left': '//' },
      \ 'opl': { 'left': "REM" },
      \ 'ora': { 'left': '#' },
      \ 'ox': { 'left': '//' },
      \ 'pascal': { 'left': '{','right': '}', 'leftAlt': '(*', 'rightAlt': '*)' },
      \ 'patran': { 'left': '$', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'pcap': { 'left': '#' },
      \ 'pccts': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'pdf': { 'left': '%' },
      \ 'pfmain': { 'left': '//' },
      \ 'php': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'pic': { 'left': ';' },
      \ 'pike': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'pilrc': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'pine': { 'left': '#' },
      \ 'plm': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'plsql': { 'left': '--', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'po': { 'left': '#' },
      \ 'postscr': { 'left': '%' },
      \ 'pov': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'povini': { 'left': ';' },
      \ 'ppd': { 'left': '%' },
      \ 'ppwiz': { 'left': ';;' },
      \ 'processing': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'prolog': { 'left': '%', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'ps1': { 'left': '#' },
      \ 'psf': { 'left': '#' },
      \ 'ptcap': { 'left': '#' },
      \ 'python': { 'left': '#' },
      \ 'radiance': { 'left': '#' },
      \ 'ratpoison': { 'left': '#' },
      \ 'r': { 'left': '#' },
      \ 'rc': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'rebol': { 'left': ';' },
      \ 'registry': { 'left': ';' },
      \ 'remind': { 'left': '#' },
      \ 'resolv': { 'left': '#' },
      \ 'rgb': { 'left': '!' },
      \ 'rib': { 'left': '#' },
      \ 'robots': { 'left': '#' },
      \ 'sa': { 'left': '--' },
      \ 'samba': { 'left': ';', 'leftAlt': '#' },
      \ 'sass': { 'left': '//', 'leftAlt': '/*' },
      \ 'sather': { 'left': '--' },
      \ 'scala': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'scilab': { 'left': '//' },
      \ 'scsh': { 'left': ';' },
      \ 'sed': { 'left': '#' },
      \ 'sgmldecl': { 'left': '--', 'right': '--' },
      \ 'sgmllnx': { 'left': '<!--', 'right': '-->' },
      \ 'sh': { 'left': '#' },
      \ 'sicad': { 'left': '*' },
      \ 'simula': { 'left': '%', 'leftAlt': '--' },
      \ 'sinda': { 'left': '$' },
      \ 'skill': { 'left': ';' },
      \ 'slang': { 'left': '%' },
      \ 'slice': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'slrnrc': { 'left': '%' },
      \ 'sm': { 'left': '#' },
      \ 'smarty': { 'left': '{*', 'right': '*}' },
      \ 'smil': { 'left': '<!', 'right': '>' },
      \ 'smith': { 'left': ';' },
      \ 'sml': { 'left': '(*', 'right': '*)' },
      \ 'snnsnet': { 'left': '#' },
      \ 'snnspat': { 'left': '#' },
      \ 'snnsres': { 'left': '#' },
      \ 'snobol4': { 'left': '*' },
      \ 'spec': { 'left': '#' },
      \ 'specman': { 'left': '//' },
      \ 'spectre': { 'left': '//', 'leftAlt': '*' },
      \ 'spice': { 'left': '$' },
      \ 'sql': { 'left': '--' },
      \ 'sqlforms': { 'left': '--' },
      \ 'sqlj': { 'left': '--' },
      \ 'sqr': { 'left': '!' },
      \ 'squid': { 'left': '#' },
      \ 'st': { 'left': '"' },
      \ 'stp': { 'left': '--' },
      \ 'systemverilog': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'tads': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'tags': { 'left': ';' },
      \ 'tak': { 'left': '$' },
      \ 'tasm': { 'left': ';' },
      \ 'tcl': { 'left': '#' },
      \ 'texinfo': { 'left': "@c " },
      \ 'texmf': { 'left': '%' },
      \ 'tex': { 'left': '%' },
      \ 'plaintex': { 'left': '%' },
      \ 'tf': { 'left': ';' },
      \ 'tidy': { 'left': '#' },
      \ 'tli': { 'left': '#' },
      \ 'tmux': { 'left': '#' },
      \ 'trasys': { 'left': "$" },
      \ 'tsalt': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'tsscl': { 'left': '#' },
      \ 'tssgm': { 'left': "comment = '", 'right': "'" },
      \ 'txt2tags': { 'left': '%' },
      \ 'uc': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'uil': { 'left': '!' },
      \ 'vb': { 'left': "'" },
      \ 'velocity': { 'left': "##", 'right': "", 'leftAlt': '#*', 'rightAlt': '*#' },
      \ 'vera': { 'left': '/*','right': '*/', 'leftAlt': '//' },
      \ 'verilog': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'verilog_systemverilog': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ 'vgrindefs': { 'left': '#' },
      \ 'vhdl': { 'left': '--' },
      \ 'vim': { 'left': '"' },
      \ 'virata': { 'left': '%' },
      \ 'vrml': { 'left': '#' },
      \ 'vsejcl': { 'left': '/*' },
      \ 'webmacro': { 'left': '##' },
      \ 'wget': { 'left': '#' },
      \ 'Wikipedia': { 'left': '<!--', 'right': '-->' },
      \ 'winbatch': { 'left': ';' },
      \ 'wml': { 'left': '#' },
      \ 'wvdial': { 'left': ';' },
      \ 'xdefaults': { 'left': '!' },
      \ 'xkb': { 'left': '//' },
      \ 'xmath': { 'left': '#' },
      \ 'xpm2': { 'left': '!' },
      \ 'xquery': { 'left': '(:', 'right': ':)' },
      \ 'z8a': { 'left': ';' }
      \ }

function! s:SetUpForNewFiletype(filetype)
  if has_key(s:delimiterMap, a:filetype)
    let b:CommenterDelims = s:delimiterMap[a:filetype]
    for i in ['left', 'leftAlt', 'right', 'rightAlt']
      if !has_key(b:CommenterDelims, i)
        let b:CommenterDelims[i] = ''
      endif
    endfor
  else
    let b:CommenterDelims = s:CreateDelimMapFromCms()
  endif
  let b:left = b:CommenterDelims['left']
  let b:right = b:CommenterDelims['right']
endfunction

function! s:CreateDelimMapFromCms()
  return {
        \ 'left': substitute(&commentstring, '\([^ \t]*\)\s*%s.*', '\1', ''),
        \ 'right': substitute(&commentstring, '.*%s\s*\(.*\)', '\1', 'g'),
        \ 'leftAlt': '',
        \ 'rightAlt': '' }
endfunction
