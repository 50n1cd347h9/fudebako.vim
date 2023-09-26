" chop given url to github repository name
function! s:get_repo_name_from_url(repo_url) abort
	let l:pattern = '\([^/]\+\)$'
	let l:repo = matchstr(a:repo_url, l:pattern)	
	return l:repo
endfunction


function! s:install_plugin() abort
	for l:repo_url in s:repo_urls
		let l:repo = s:get_repo_name_from_url(l:repo_url)
		let l:clone_dir = s:path .. 'plugins/' .. l:repo	
		" if repo not installed
		if !isdirectory(expand(l:clone_dir)) 
			let l:command = 'git clone' .. ' ' .. l:repo_url .. ' ' .. l:clone_dir
			echo system(l:command)
		endif
		"let &packpath .= ',' . l:clone_dir
		let &runtimepath .= ',' . l:clone_dir
	endfor	
endfunction


function! s:uninstall_plugin()
	let l:ls = 'ls' .. ' ' .. s:path .. 'plugins'

	let l:result = system(l:ls)
	let l:repos_installed = split(l:result, '\n')
	let l:repos_wont_dissapear = []
	for l:repo_url in s:repo_urls
		call add(l:repos_wont_dissapear, s:get_repo_name_from_url(l:repo_url))
	endfor
	for l:repo in l:repos_installed
		if index(l:repos_wont_dissapear, l:repo) ==# -1
			let l:repo_dir = s:path .. 'plugins/' .. l:repo
			let l:command = 'rm -rf' .. ' ' .. l:repo_dir	
			echo system(l:command)
		endif
	endfor		
endfunction


function! s:make_url_array()
	let l:repo_urls = readfile(s:path .. 'repos.vim')
	let l:i = 0
	for l:item in l:repo_urls
		if l:item !~ '^"' && l:item != ''
			let l:repo_urls[i] = l:item
			let l:i += 1
		endif
	endfor
	for i in range(1, len(l:repo_urls)-i)
		call remove(l:repo_urls, -1)
	endfor
	return l:repo_urls
endfunction


if has('nvim')
	let s:path = expand('~/.config/nvim/')
	let s:command = 'ls' .. ' ' .. s:path .. 'plugins'
else
	let s:path = expand('~/.vim/')
endif


let s:repo_urls = s:make_url_array()
call s:install_plugin()
call s:uninstall_plugin()



