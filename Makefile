# Makefile for Sphinx documentation

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build

# User-friendly check for sphinx-build
ifeq ($(shell which $(SPHINXBUILD) >/dev/null 2>&1; echo $$?), 1)
$(error The '$(SPHINXBUILD)' command was not found. Make sure you have Sphinx installed, then set the SPHINXBUILD environment variable to point to the full path of the '$(SPHINXBUILD)' executable. Alternatively you can add the directory with the executable to your PATH. If you don't have Sphinx installed, grab it from http://sphinx-doc.org/)
endif

# Internal variables.
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(SPHINXOPTS) .
SPHINX_LIVE_PORT = 8001

DEPLOY_HOST   = daniel-siepmann.de
DEPLOY_PATH   = htdocs/daniel-siepmann.de
DEPLOY_PATH   = htdocs/new.daniel-siepmann.de

COMPASS_CONFIG_PATH = _compass/

.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html       to make standalone HTML files"
	@echo "  dirhtml    to make HTML files named index.html in directories"
	@echo "  singlehtml to make a single large HTML file"
	@echo "  changes    to make an overview of all changed/added/deprecated items"
	@echo "  linkcheck  to check all external links for integrity"
	@echo "  deploy     to deploy the generated HTML to production"

.PHONY: clean
clean:
	rm -rf $(BUILDDIR)/*

.PHONY: livehtml
livehtml: css
	# Ignore some folders and define port
	sphinx-autobuild -b html -i '*.sw[pmnox]' -i '*/_compass/*' -i '.git*' -i '*~' -p $(SPHINX_LIVE_PORT) $(ALLSPHINXOPTS) $(BUILDDIR)/html

.PHONY: html
html: clean css
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

.PHONY: dirhtml
dirhtml: css
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

.PHONY: singlehtml
singlehtml: css
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	@echo
	@echo "Build finished. The HTML page is in $(BUILDDIR)/singlehtml."

.PHONY: changes
changes:
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
	@echo
	@echo "The overview file is in $(BUILDDIR)/changes."

.PHONY: linkcheck
linkcheck:
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

.PHONY: css
css:
	cd $(COMPASS_CONFIG_PATH) && compass compile --force

# TODO: Add testing? Via gherkin to test before deployment locally and after
#       deployment production? Use a Variable which defines context? / URL?
#       Also part of it should be the linkchecker?!

.PHONY: deploy
deploy: clean css html
	# TODO: Raise version on each deploy?
	#       Enables generation of changelogs
	rsync --delete -vaz $(BUILDDIR)/html/* $(DEPLOY_HOST):$(DEPLOY_PATH)
