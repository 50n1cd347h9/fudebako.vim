" == functions ===================================================================
function! s:get_repo_name_from_url(repo_url) abort
	let l:pattern = '\([^/]\+\)$'
	let l:repo = matchstr(a:repo_url, l:pattern)
	
	return l:repo
endfunction


function! s:install_plugin(repo_urls) abort
	for l:repo_url in a:repo_urls
		let l:repo = s:get_repo_name_from_url(l:repo_url)
		let l:clone_dir = '~/.vim/pack/plugins/start/' .. l:repo
	
		" if repo not installed
		if !isdirectory(expand(l:clone_dir)) 
			let l:command = 'git clone' .. ' ' .. l:repo_url .. ' ' .. l:clone_dir
			echo system(l:command)
		endif

		let &packpath .= ',' . l:clone_dir
	endfor	
endfunction


" インストールされているプラグインがrepos.vimに存在しないときアンインストール
function! s:uninstall_plugin()
	let l:result = system('ls ~/.vim/pack/plugins/start')
	let l:repos_installed = split(l:result, '\n')
	let l:repos_wont_dissapear = []
	for l:repo_url in s:repo_urls
		call add(l:repos_wont_dissapear, s:get_repo_name_from_url(l:repo_url))
	endfor

	for l:repo in l:repos_installed
		if index(l:repos_wont_dissapear, l:repo) ==# -1
			let l:repo_dir = '~/.vim/pack/plugins/start/' .. l:repo
			let l:command = 'rm -rf' .. ' ' .. l:repo_dir
			
			echo system(l:command)
		endif
	endfor		
endfunction
" =====================================================================================


" == make repository urls array ==========================================
let s:repo_urls = readfile(expand('~/.vim/repos.vim'))

let i = 0
for item in s:repo_urls
	if item !~ '^"' && item != ''
		let s:repo_urls[i] = item
		let i += 1
	endif
endfor

for i in range(1, len(s:repo_urls)-i)
	call remove(s:repo_urls, -1)
endfor
" ===============================================


" == call functions ==========================
call s:install_plugin(s:repo_urls)
call s:uninstall_plugin()
" ======================================

