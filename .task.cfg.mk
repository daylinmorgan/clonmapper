.DEFAULT_GOAL := help
log = $(if $(tprint),$(call tprint,{a.bold}==> {a.magenta}$(1){a.end}),@echo '==> $(1)')
USAGE = {a.bold}{a.cyan}ClonMapper Protocol Tasks{a.end}\n\t{a.green}make{a.end}: <recipe>\n
PRINT_VARS = HTML_FLAGS LATEX_FLAGS
PHONIFY = true

-include .task.mk
$(if $(wildcard .task.mk),,.task.mk: ; curl -fsSL https://raw.githubusercontent.com/daylinmorgan/task.mk/v23.1.2/task.mk -o .task.mk)
