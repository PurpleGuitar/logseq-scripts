# !/bin/bash

# Uncomment to debug
# set -x

# Set clipboard tool based on whether we're X11 or Wayland
if [ -n "$WAYLAND_DISPLAY" ]; then
    PASTE_FROM_CLIPBOARD="wl-paste"  # Wayland
else
    PASTE_FROM_CLIPBOARD="xclip -o"  # X11
fi

# Ensure LOGSEQ_SCRIPTS_DIR is set
if [ -z "${LOGSEQ_SCRIPTS_DIR:-}" ]; then
    echo "ERROR: LOGSEQ_SCRIPTS_DIR is not set. Export LOGSEQ_SCRIPTS_DIR (e.g. export LOGSEQ_SCRIPTS_DIR=logseq-scripts) and try again." >&2
    exit 1
fi

# Copy clipboard content to temp file.  We use the .txt extension to prevent
# logseq from trying to interpret it as a markdown file.
MARKDOWN_FILE="out.txt"
$PASTE_FROM_CLIPBOARD > ${MARKDOWN_FILE}

# If LOGSEQ_DOC_TITLE is not set, notify the user how to set it
if [ -z "${LOGSEQ_DOC_TITLE:-}" ]; then
    echo "WARNING: LOGSEQ_DOC_TITLE is not set." >&2
    echo "You may see warnings about missing titles." >&2
fi

# Correct asset paths in markdown content
# e.g. "../assets/image.png" to "assets/image.png"
sed -i -E 's|\.\./assets/|assets/|g' ${MARKDOWN_FILE}

# Remove e.g. "{:height 800, :width 600}" from image links
sed -i -E 's/\{\:height[[:space:]]+[0-9]+,[[:space:]]+:width[[:space:]]+[0-9]+\}//g' ${MARKDOWN_FILE}

# to HTML
pandoc ${MARKDOWN_FILE} \
    -f markdown \
    -t html \
    --standalone \
    --css assets/logseq-to-html.css \
    --metadata title="${LOGSEQ_DOC_TITLE}" \
    -o "out.html"

# to DOCX
pandoc ${MARKDOWN_FILE} \
    -f markdown \
    -t docx \
    --standalone \
    --metadata title="${LOGSEQ_DOC_TITLE}" \
    -o "out.docx"

# to reveal.js
pandoc ${MARKDOWN_FILE} \
    -f markdown \
    -t revealjs \
    --css assets/logseq-to-revealjs.css \
    --standalone \
    --metadata theme="white" \
    --metadata transition="fade" \
    --metadata backgroundTransition="none" \
    --metadata title="${LOGSEQ_DOC_TITLE}" \
    -V revealjs-url="https://unpkg.com/reveal.js" \
    -o "out.revealjs.html"

# to PPTX
pandoc ${MARKDOWN_FILE} \
    -f markdown \
    -t pptx \
    --standalone \
    --metadata title="${LOGSEQ_DOC_TITLE}" \
    -o "out.pptx"

# # to ChordPro PDF
# chordpro \
#     --config=${LOGSEQ_SCRIPTS_DIR}/chordpro-config.json \
#     --page-size="letter" \
#     --output="out.chordpro.pdf" \
#     ${MARKDOWN_FILE}

# # to PDF
# pandoc ${MARKDOWN_FILE} \
#     -f markdown \
#     -t pdf \
#     --standalone \
#     --metadata title="${LOGSEQ_DOC_TITLE}" \
#     -o "out.pdf"

# # to Beamer
# pandoc ${MARKDOWN_FILE} \
#     -f markdown \
#     -t beamer \
#     --standalone \
#     --metadata title="${LOGSEQ_DOC_TITLE}" \
#     -o "out.beamer.pdf"

