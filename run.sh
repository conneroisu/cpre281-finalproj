
#!/bin/bash

# Script to process markdown (with optional citations) to html via pandoc
# Specifically this first converts markdown wikilinks in this [[form]] to
# be [form](./form.html) via a sed convertions and passes the modified
# stream to pandoc. The first argument to the script is a markdown file
# (note .md extension is assumed), and the second optional argument is the
# bibliography file.

TARGET=$(basename $1 .md)
PDOPTS="--from markdown+simple_tables+wikilinks_title_after_pipe --standalone --table-of-contents"
if [ -n "$2" ] ; then PDOPTS=$PDOPTS" --bibliography="$2" --csl ieee" ; fi
SEDSTR="s/\[\[\([0-9A-Za-z]\{1,\}\)\(\]\]\)/[\1](.\/\1.html)/g"

# Convert [[links]] to [links](./links.html) and process markdown
sed $SEDSTR < $1 | pandoc $PDOPTS -o "$TARGET".html
sed -i 's/max-width: 36em/max-width: 50em/g' $TARGET.html

# append stylesheet to html
# similar to:  cat ./styles.css >> $TARGET.html
echo "<style>" >> $TARGET.html
cat ./styles.css >> $TARGET.html
echo "</style>" >> $TARGET.html
