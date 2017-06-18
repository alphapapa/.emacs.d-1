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

travis: travis-setup
	cask exec buttercup -L tests \
                    -L site-lisp \
                    -L files \
                    --eval "(setq undercover--send-report nil)" \
                    tests

bootstrap:
	cask exec emacs --batch -L site-lisp -l my-bootstrap -f my-create-cache

all: bootstrap test
