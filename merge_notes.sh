#!/bin/bash

VAULT="/Users/victorhaynes/Documents/AWS Solution Architect Associate"

# Loop over Section folders in numerical order
find "$VAULT" -maxdepth 1 -type d -name "Section*" | sort -V | while IFS= read -r section; do
    section_name=$(basename "$section")
    OUTPUT="${section_name}.md"

    > "$OUTPUT"  # Clear previous output
    echo "# $section_name" >> "$OUTPUT"

    # Loop over Markdown files inside folder, sorted numerically
    find "$section" -maxdepth 1 -type f -name "*.md" | sort -V | while IFS= read -r file; do
        note_title=$(basename "$file" .md)
        echo -e "\n## $note_title\n" >> "$OUTPUT"

        # Process each line
        while IFS= read -r line; do
            # Case 1: Obsidian-style image ![[...]]
            if [[ "$line" =~ "!\\[\\[" ]]; then
                img_name=$(echo "$line" | sed -E 's|!\[\[([^\]]+)\]\]|\\1|')
                img_file="${section}/${img_name}"

                if [[ -f "$img_file" ]]; then
                    mime=$(file --mime-type -b "$img_file")
                    b64=$(base64 "$img_file" | tr -d '\n')
                    line="![${img_name}](data:${mime};base64,${b64})"
                else
                    # Fall back to a normal Markdown image with %20 encoding
                    img_url=$(echo "$img_name" | sed 's/ /%20/g')
                    line="![${img_name}](${img_url})"
                fi

            # Case 2: Standard Markdown image ![...](...)
            elif [[ $line =~ \!\[(.*)\]\((.*)\) ]]; then
                alt="${BASH_REMATCH[1]}"
                file_ref="${BASH_REMATCH[2]}"

                # Try relative to current section
                img_file="${section}/${file_ref}"
                if [[ -f "$img_file" ]]; then
                    mime=$(file --mime-type -b "$img_file")
                    b64=$(base64 "$img_file" | tr -d '\n')
                    line="![${alt}](data:${mime};base64,${b64})"
                fi
            fi

            echo "$line" >> "$OUTPUT"
        done < "$file"
    done

    echo "Built ${OUTPUT}"
done

echo "All sections processed."
