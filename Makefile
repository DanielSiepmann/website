# Makefile for Sphinx documentation

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build

# Internal variables.
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(SPHINXOPTS) source
SPHINX_LIVE_PORT = 8001

DEPLOY_HOST   = daniel-siepmann.de
# DEPLOY_PATH   = htdocs/daniel-siepmann.de
DEPLOY_PATH   = htdocs/new.daniel-siepmann.de

COMPASS_CONFIG_PATH = source/_compass/

CURRENT_DIR = $(shell pwd)

.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo " Generation: "
	@echo "     html        to make standalone HTML files"
	@echo " Validation and deployment: "
	@echo "     changes     to make an overview of all changed/added/deprecated items"
	@echo "     linkcheck   to check all external links for integrity"
	@echo "     deploy      to deploy the generated HTML to production"
	@echo " Environment setup: "
	@echo "     clean       to remove build results"
	@echo "     install     to install all dependencies local for current user"
	@echo "     optimize    to optimize images"

.PHONY: install
install:
	docker build -t registry.gitlab.com/danielsiepmann/website-sphinx Docker
	# docker push registry.gitlab.com/danielsiepmann/website-sphinx

.PHONY: optimize
optimize:
	docker run --rm \
		-v $(CURRENT_DIR):/srv/project \
		--entrypoint bash \
		--user="`id -u`:`id -g`" \
		registry.gitlab.com/danielsiepmann/website-sphinx \
		-c "cd /srv/project && pngquant -v source/images/**/*.png --ext .png -f"
	docker run --rm \
		-v $(CURRENT_DIR):/srv/project \
		--entrypoint bash \
		--user="`id -u`:`id -g`" \
		registry.gitlab.com/danielsiepmann/website-sphinx \
		-c "cd /srv/project && optipng source/images/**/*.png"

.PHONY: clean
clean:
	docker rmi registry.gitlab.com/danielsiepmann/website-sphinx
	rm -rf $(BUILDDIR)/*

.PHONY: livehtml
livehtml: css
	rm -rf $(BUILDDIR)/*
	# Ignore some folders and define port
	docker run --rm \
		-v $(CURRENT_DIR):/srv/project \
		--entrypoint bash \
		--user="`id -u`:`id -g`" \
		-p 127.0.0.1:$(SPHINX_LIVE_PORT):$(SPHINX_LIVE_PORT) \
		registry.gitlab.com/danielsiepmann/website-sphinx \
		-c "cd /srv/project && sphinx-autobuild -H 0.0.0.0 -b html -i '*.sw[pmnox]' -i '*.dotfiles/*' -i '*/_compass/*' -i '.git*' -i '*~' -p $(SPHINX_LIVE_PORT) $(ALLSPHINXOPTS) $(BUILDDIR)/html"

.PHONY: html
html: css
	docker run --rm \
		-v $(CURRENT_DIR):/srv/project \
		--entrypoint bash \
		--user="`id -u`:`id -g`" \
		registry.gitlab.com/danielsiepmann/website-sphinx \
		-c "cd /srv/project && $(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html"
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

.PHONY: changes
changes:
	docker run --rm \
		-v $(CURRENT_DIR):/srv/project \
		--entrypoint bash \
		--user="`id -u`:`id -g`" \
		registry.gitlab.com/danielsiepmann/website-sphinx \
		-c "cd /srv/project && $(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes"
	@echo
	@echo "The overview file is in $(BUILDDIR)/changes."

.PHONY: linkcheck
linkcheck:
	docker run --rm \
		-v $(CURRENT_DIR):/srv/project \
		--entrypoint bash \
		--user="`id -u`:`id -g`" \
		registry.gitlab.com/danielsiepmann/website-sphinx \
		-c "cd /srv/project && $(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck"
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

.PHONY: css
css:
	rm -rf source/_compass/.sass-cache/
	rm -rf source/_static/stylesheets/
	docker run --rm \
		-v $(CURRENT_DIR):/srv/project \
		--entrypoint bash \
		--user="`id -u`:`id -g`" \
		registry.gitlab.com/danielsiepmann/website-sphinx \
		-c "cd /srv/project/$(COMPASS_CONFIG_PATH) && compass compile --force"

.PHONY: deploy
deploy: html optimize
	rsync --delete -vaz $(BUILDDIR)/html/* $(DEPLOY_HOST):$(DEPLOY_PATH)

.PHONY: deploy-light
deploy-light: html
	rsync --delete -vaz $(BUILDDIR)/html/* $(DEPLOY_HOST):$(DEPLOY_PATH)
