" chop given url to github repository name
function! s:GetRepoNameFromUrl(repo_url) abort
	let l:pattern = '\([^/]\+\)$'
	let l:repo = matchstr(a:repo_url, l:pattern)	
	return l:repo
endfunction


function! s:InstallPlugin() abort
	for l:repo_url in s:repo_urls
		let l:repo = s:GetRepoNameFromUrl(l:repo_url)
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


function! s:UninstallPlugin()
	let l:ls = 'ls' .. ' ' .. s:path .. 'plugins'

	let l:result = system(l:ls)
	let l:repos_installed = split(l:result, '\n')
	let l:repos_wont_dissapear = []
	for l:repo_url in s:repo_urls
		call add(l:repos_wont_dissapear, s:GetRepoNameFromUrl(l:repo_url))
	endfor
	for l:repo in l:repos_installed
		if index(l:repos_wont_dissapear, l:repo) ==# -1
			let l:repo_dir = s:path .. 'plugins/' .. l:repo
			let l:command = 'rm -rf' .. ' ' .. l:repo_dir	
			echo system(l:command)
		endif
	endfor		
endfunction

function! s:GetJsonFromYaml(yaml_path) abort
	let l:python_path = '~/workspace/fudebako.vim/venv/bin/python3'
	let l:cmd = expand(join([python_path, './yaml2json.py', a:yaml_path], ' '))
	let l:json_text = system(cmd)
	return json_decode(l:json_text)
endfunction

function! s:MakeUrlArray()
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
else
	let s:path = expand('~/.vim/')
endif


let s:repo_urls = s:MakeUrlArray()
call s:InstallPlugin()
call s:UninstallPlugin()

echo s:GetJsonFromYaml(expand('~/workspace/fudebako.vim/languages.yaml'))
