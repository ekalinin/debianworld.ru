find-second-parts:
	@find ./source/ -iname "*-2.md"

build:
	@hexo generate

dev:
	@hexo server -d

prod:
	@hexo server -l combined

env:
	@nv on dw-hexo-2.8.3

init:
	@npm install
