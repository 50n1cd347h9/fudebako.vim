" chop given url to github repository name
function! s:GetRepoNameFromUrl(repo_url) abort
	let pattern = '\([^/]\+\)$'
	let repo = matchstr(a:repo_url, pattern)	
	return repo
endfunction

function StrStr(haystack, needle) abort
	let idx = stridx(a:haystack, a:needle)
	if idx < 0
		return ''
	endif

	return strpart(a:haystack, idx)
endfunction

function! s:GetInstalled() abort
	let result =  glob(s:plugin_path . '/*', 0, 1)
	let result += glob(s:delayed_path .'/*', 0, 1)
	" remove delayed in plugin_path
	call filter(result, {_, val -> StrStr(s:delayed_path, val) ==# ''})
	return result
endfunction

function! s:UninstallPlugin(json) abort
	let urls = a:json['plugins']
	let delayed = get(a:json, 'delayed', v:null)

	if delayed isnot v:null
		for item in delayed
			let url = item['url']
			call add(urls, url)
		endfor
	endif

	let installed = s:GetInstalled()

	let plugins_remain = []
	for url in urls
		call add(plugins_remain, s:GetRepoNameFromUrl(url))
	endfor

	for path in installed
		let base_path = fnamemodify(path, ':t')
		if index(plugins_remain, base_path) ==# -1
			echo system(join(['rm', '-rf', path], ' '))
		endif
	endfor		
endfunction


function! s:GetJsonFromYaml() abort
	let yaml_path = join([s:config_path, 'plugins.yaml'], '/')
	let cmd = join(['yq', '.', yaml_path], ' ')
	let json_text = system(cmd)
	return json_decode(json_text)
endfunction


function! s:IsValidUrl(url) abort
	return a:url !~ '^"' && a:url != ''
endfunction


function! s:PluginExists(plugin_dir) abort
	return isdirectory(expand(a:plugin_dir)) 
endfunction


function! s:GitClone(url, clone_dir) abort
	let cmd = join(['git', 'clone', a:url, a:clone_dir], ' ')
	echo system(cmd)
endfunction


function! s:InstallPlugin(clone_dir, url)abort
	if !s:PluginExists(a:clone_dir)
		call s:GitClone(a:url, a:clone_dir)
	endif
endfunction

function! s:InstallAllPlugins(urls) abort
	for url in a:urls
		let repo_name = s:GetRepoNameFromUrl(url)
		let clone_dir = join([s:plugin_path, repo_name], '/')

		call s:InstallPlugin(clone_dir, url)
		let &runtimepath .= ',' . clone_dir
	endfor	
endfunction


function! s:ExecuteAutoCmd(autocmd_conf) abort
	let url = get(a:autocmd_conf, 'url', v:null)
	if url is# v:null
		return
	endif

	" list of string expected
	let filetype = get(a:autocmd_conf, 'filetype', v:null)
	" list of string expected
	let cmd = get(a:autocmd_conf, 'cmd', v:null)
	" list of string expected
	let cond = get(a:autocmd_conf, 'condition', v:null)
	let cmd_list = ['autocmd']

	if filetype isnot v:null
		call add(cmd_list, 'FileType')
		call add(cmd_list, join(filetype, ','))
	elseif cmd isnot v:null
		call add(cmd_list, 'CmdUndefined')
		call add(cmd_list, join(cmd, ','))
	elseif cond isnot v:null
		call add(cmd_list, cond)
	else
		return
	endif

	let repo_name = s:GetRepoNameFromUrl(url)
	let clone_dir = join([s:delayed_path, repo_name], '/')

	call add(cmd_list, printf(
		\ '++once call %s(%s, %s) | packadd %s',
		\ '<SID>InstallPlugin',
		\ string(clone_dir),
		\ string(url),
		\ repo_name,
		\))
	let autocmd_str = join(cmd_list, ' ')

	execute autocmd_str
endfunction

function! s:SubmitDelayed(delayed) abort
	let &packpath .= ',' . s:config_path
	for item in a:delayed
		call s:ExecuteAutoCmd(item)
	endfor
endfunction



function! s:Main() abort
	let config_json = s:GetJsonFromYaml()
	let urls = get(config_json, 'plugins', [])
	let delayed = get(config_json, 'delayed', [])


	call s:InstallAllPlugins(urls)
	call s:SubmitDelayed(delayed)

	call s:UninstallPlugin(config_json)
endfunction

if has('nvim')
	let s:config_path = expand('~/.config/nvim')
else
	let s:config_path = expand('~/.vim')
endif
let s:plugin_path = join([s:config_path, 'pack'], '/')
let s:delayed_path = join([s:plugin_path, 'delayed/opt'], '/')

call s:Main()
