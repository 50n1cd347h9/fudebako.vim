let s:repos = readfile(expand("./repos.yaml"))


for s:item in s:repos
	echo s:item
endfor
