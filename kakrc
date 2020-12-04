source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "robertmeta/plug.kak" noload
plug "robertmeta/nofrils-kakoune" theme
plug "vktec/kaklip"
plug "vktec/c4.kak"
plug "https://gitlab.com/Screwtapello/kakoune-inc-dec" %{
	map global normal <c-a> ': inc-dec-modify-numbers + %val{count}<ret>'
	map global normal <c-x> ': inc-dec-modify-numbers - %val{count}<ret>'
}

set global tabstop 4
set global indentwidth 0
addhl global/ number-lines -separator ' ' -min-digits 3
addhl global/ show-matching
addhl global/ wrap -word -indent -marker '   ⮩  '

map global user c ': comment-line<ret>'
map global user u '! unicode -t '

hook global WinSetOption filetype=gas %{
	set buffer tabstop 8
}

hook global BufWritePre .*\.go %{
	exec -draft '%|safefmt goimports<ret>'
}

hook global BufWritePre .*\.c %{
	exec -draft '%|clang-format<ret>'
}

hook global WinSetOption filetype=haskell %{
	set buffer tabstop 4
	set buffer indentwidth 4
	hook buffer InsertKey <tab> %{ exec -draft h@ }
	map buffer insert <backspace> '<a-;>:backspace-space-indent<ret>'
	define-command -hidden backspace-space-indent %{
		try %{
			# delete tabstop spaces before cursor
			exec -draft h %opt{tabstop}HL <a-k>\A<space>+\z<ret> d
		} catch %{
			exec <backspace>
		}
	}
}

define-command -docstring 'copy a breakpoint command for use in a debugger' breakpoint %{
	set-register '"' "b %val{buffile}:%val{cursor_line}"
}

colorscheme nofrils
