.PHONY: bootstrap test travis travis-setup

test:
	cask exec buttercup -L tests \
                    -L site-lisp \
                    -L files \
                    --eval "(setq undercover--send-report nil)" \
                    ${BUTTERCUP_OPTIONS} tests

travis-setup:
	cp Cask.travis Cask
	mkdir dev
	cask install
	cd projects
	git clone https://github.com/Fuco1/dired-hacks
	git clone https://github.com/Fuco1/org-clock-budget
	git clone https://github.com/Fuco1/org-timeline

tangled_files = $(patsubst %.org, %-tangled.el, $(wildcard files/*.org))

files/%-tangled.el: files/%.org travis-setup
	cask exec emacs --batch --eval "(progn (require 'ob-tangle) (org-babel-tangle-file \"$<\"))"

tangle-org-files: $(tangled_files)

travis: travis-setup tangle-org-files
	cask exec buttercup -L tests \
                    -L site-lisp \
                    -L files \
                    --eval "(setq undercover--send-report nil)" \
                    tests

bootstrap:
	cask exec emacs --batch -L site-lisp -l my-bootstrap -f my-create-cache

all: bootstrap test
