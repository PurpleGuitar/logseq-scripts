# This file is intended to be run from your logseq vault root directory, e.g.:
# make -f /path/to/logseq-scripts/makefile <target>
# or by symlinking this makefile into your vault root directory.

# Ensure LOGSEQ_SCRIPTS_DIR is defined. 
# This should be the path to your logseq-scripts directory.
ifndef LOGSEQ_SCRIPTS_DIR
$(error LOGSEQ_SCRIPTS_DIR is not set, please set it to the logseq-scripts dir)
endif

# Ensure LOGSEQ_BACKUP_DIR is defined.
# This should be the path to your backup directory.
ifndef LOGSEQ_BACKUP_DIR
$(error LOGSEQ_BACKUP_DIR is not set, please set it to your backup directory)
endif

.PHONY: reports
reports: empty-pages find-orphaned-assets

.PHONY: empty-pages
empty-pages:
	@echo ""
	@echo "Empty pages"
	@echo "=================="
	@find journals -type f -exec grep -ILv '^[[:space:]]*$$' {} \;
	@find pages -type f -exec grep -ILv '^[[:space:]]*$$' {} \;

.PHONY: find-orphaned-assets
find-orphaned-assets:
	@echo ""
	@echo "Orphaned Assets"
	@echo "=================="
	@bash $(LOGSEQ_SCRIPTS_DIR)/find-orphaned-assets.bash

.PHONY: remove-orphaned-assets
remove-orphaned-assets:
	@echo "The following orphaned assets will be removed:"
	@bash $(LOGSEQ_SCRIPTS_DIR)/find-orphaned-assets.bash
	@read -p "Are you sure you want to remove these files? (y/N) " confirm && \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		    bash $(LOGSEQ_SCRIPTS_DIR)/find-orphaned-assets.bash | xargs rm -v; \
	else \
	    echo "Aborted. No files were removed."; \
	fi

.PHONY: backup
backup:
	tar czfv $(LOGSEQ_BACKUP_DIR)/$(notdir $(CURDIR))-backup-$$(date +"%Y-%m-%d_%H-%M-%S").tar.gz .

.PHONY: docs-from-clipboard
docs-from-clipboard:
	@bash $(LOGSEQ_SCRIPTS_DIR)/docs-from-clipboard.bash

.PHONY: clean
clean:
	@# From docs-from-clipboard.bash
	@rm -f out.txt
	@rm -f out.html
	@rm -f out.revealjs.html
	@rm -f out.docx
	@rm -f out.pptx
	@rm -f out.pdf
	@rm -f out.chordpro.pdf
	@rm -f out.beamer.pdf