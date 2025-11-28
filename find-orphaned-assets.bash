# !/bin/bash

# This script identifies and lists orphaned assets in the .assets directory.  An
# orphaned asset is a file in the assets directory that is not referenced by any
# file in the `journals/` or `pages/` directories, or in specific special files.

# Ensure LOGSEQ_SCRIPTS_DIR is set
if [ -z "${LOGSEQ_SCRIPTS_DIR:-}" ]; then
    echo "ERROR: LOGSEQ_SCRIPTS_DIR is not set. Export LOGSEQ_SCRIPTS_DIR (e.g. export LOGSEQ_SCRIPTS_DIR=logseq-scripts) and try again." >&2
    exit 1
fi

ASSETS_DIR="assets"
SOURCE_DIRS=("journals" "pages")
SPECIAL_FILES=(
    "logseq/config.edn" 
    "logseq/custom.css"
)
ORPHANED_ASSETS=()

# Function to check if an asset is referenced in any source file
is_asset_referenced() {
    local asset="$1"
    # Check each source directory for references to the asset
    for dir in "${SOURCE_DIRS[@]}"; do
        if grep -qr "$asset" "$dir"; then
            return 0  # Asset is referenced
        fi
    done
    # Also check special files for references
    for special_file in "${SPECIAL_FILES[@]}"; do
        if grep -qr "$asset" "$special_file"; then
            return 0  # Asset is referenced
        fi
    done
    # Asset is not found in any source file
    return 1 
}

# Iterate over each file in the assets directory
for asset in "$ASSETS_DIR"/*; do
    if ! is_asset_referenced "$(basename "$asset")"; then
        ORPHANED_ASSETS+=("$asset")
    fi
done

# Output the list of orphaned assets (inverted condition)
if [ ${#ORPHANED_ASSETS[@]} -ne 0 ]; then
    for orphan in "${ORPHANED_ASSETS[@]}"; do
        echo "$orphan"
    done
fi
