" chop given url to github repository name
function! s:GetRepoNameFromUrl(repo_url) abort
	let l:pattern = '\([^/]\+\)$'
	let l:repo = matchstr(a:repo_url, l:pattern)	
	return l:repo
endfunction


function! s:UninstallPlugin(config_path, json) abort
	let l:urls = a:json['plugins']
	let l:delayed = get(a:json, 'delayed', v:null)

	if l:delayed isnot v:null
		for l:item in l:delayed
			let l:url = l:item['url']
			add(urls, url)
		endfor
	endif

	let l:ls = join(['ls', a:config_path .. 'plugins'])
	let l:result = system(l:ls)
	let l:installed = split(l:result, '\n')

	let l:repos_remain = []
	for l:url in l:urls
		call add(l:repos_remain, s:GetRepoNameFromUrl(l:url))
	endfor

	for l:repo in l:installed
		if index(l:repos_remain, l:repo) ==# -1
			let l:repo_dir = a:config_path .. 'plugins/' .. l:repo
			let l:cmd = join(['rm', '-rf', l:repo_dir], ' ')
			echo 'removing ' .. l:repo 
			echo system(l:cmd)
		endif
	endfor		
endfunction


function! s:GetJsonFromYaml(config_path) abort
	let l:yaml_path = a:config_path .. 'plugins.yaml'
	let l:yaml2json = a:config_path .. 'fudebako.vim/yaml2json.py'
	let l:python_path = a:config_path .. 'venv/bin/python3'

	let l:cmd = join([python_path, l:yaml2json, l:yaml_path], ' ')
	let l:json_text = system(cmd)
	return json_decode(l:json_text)
endfunction


function! s:IsValidUrl(url) abort
	return a:url !~ '^"' && a:url != ''
endfunction


function! s:PluginExists(plugin_dir) abort
	return isdirectory(expand(a:plugin_dir)) 
endfunction


function! s:GitClone(url, clone_dir) abort
	let l:cmd = join(['git', 'clone', a:url, a:clone_dir], ' ')
	echo system(l:cmd)
endfunction


function! s:InstallPlugin(config_path, urls) abort
	for l:url in a:urls
		let l:repo_name = s:GetRepoNameFromUrl(l:url)
		let l:clone_dir = a:config_path .. 'plugins/' .. l:repo_name

		" if repo not installed
		if !s:PluginExists(l:clone_dir)
			call s:GitClone(l:url, l:clone_dir)
		else
			echo l:clone_dir .. " already installed."
		endif

		let &runtimepath .= ',' . l:clone_dir
	endfor	
endfunction


function! s:Main() abort
	if has('nvim')
		let l:config_path = expand('~/.config/nvim/')
	else
		let l:config_path = expand('~/.vim/')
	endif

	let l:config_json = s:GetJsonFromYaml(l:config_path)
	let l:urls = config_json['plugins']

	call s:InstallPlugin(l:config_path, l:urls)
	call s:UninstallPlugin(l:config_path, l:config_json)
endfunction

call s:Main()
