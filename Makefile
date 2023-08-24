# targets that aren't filenames
.PHONY: all clean deploy build serve

all: build

BIBBLE = bibble

_includes/pubs.html: bib/pubs.bib bib/publications.tmpl
	mkdir -p _includes
	$(BIBBLE) $+ > $@

# build: _includes/pubs.html
build:
	jekyll build
ifeq ($(OS),Windows_NT)
	xcopy /E /I /Y public\_site\*
else
	cp -rf public/* _site/
endif


# you can configure these at the shell, e.g.:
# SERVE_PORT=5001 make serve
SERVE_HOST ?= 127.0.0.1
SERVE_PORT ?= 5000

# We aren't using bibble so remove its support
# serve: _includes/pubs.html
serve:
	jekyll serve --port $(SERVE_PORT) --host $(SERVE_HOST)

clean:
ifeq ($(OS),Windows_NT)
	rd /s /q _site
else
	rm -rf _site
endif

DEPLOY_HOST ?= imagine@imagine.virtual.uniandes.edu.co
DEPLOY_PATH ?= /var/www/html/
RSYNC := rsync -uvh --compress --recursive --checksum --itemize-changes --delete -e "ssh "

deploy: clean build
	$(RSYNC) _site/ $(DEPLOY_HOST):$(DEPLOY_PATH)
