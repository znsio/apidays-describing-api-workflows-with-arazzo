#!/bin/bash

# Directory to scan for markdown files
PRODUCTS_DIR="./products"

# Function to create valid file names
sanitize_folder_name() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[[:space:]]/-/g' | tr -cd '[:alnum:]-'
}

# Process each markdown file in the directory
find "$PRODUCTS_DIR" -type f -name "*.md" | while read -r markdown_file; do
    echo "Processing $markdown_file..."

    # Extract folder name for naming images
    folder_name=$(basename "$(dirname "$markdown_file")")
    sanitized_folder_name=$(sanitize_folder_name "$folder_name")

    # Directory for images within the product folder
    output_dir="$(dirname "$markdown_file")/images/embedded"
    mkdir -p "$output_dir"

    # Temporary file to store the modified markdown content
    temp_file=$(mktemp)

    # Variables to track Mermaid blocks
    in_mermaid_block=false
    mermaid_content=""
    block_counter=1

    # Process each line of the markdown file
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ "$line" == '```mermaid' ]]; then
            # Start of a Mermaid block
            in_mermaid_block=true
            mermaid_content=""
        elif [[ "$line" == '```' && $in_mermaid_block == true ]]; then
            # End of a Mermaid block
            in_mermaid_block=false

            # Generate the output filename
            output_file="$output_dir/${sanitized_folder_name}-${block_counter}.png"
            block_counter=$((block_counter + 1))

            # Call the Kroki API to generate the image
            echo "$mermaid_content" | curl -s -X POST https://kroki.io/mermaid/png --data-binary @- --output "$output_file"

            # Replace the Mermaid block with the image reference
            relative_path="./images/embedded/$(basename "$output_file")"
            echo "![Generated Diagram]($relative_path)" >> "$temp_file"
        elif [[ $in_mermaid_block == true ]]; then
            # Inside a Mermaid block, collect content
            mermaid_content+="$line"$'\n'
        else
            # Write non-Mermaid content directly to the temporary file
            echo "$line" >> "$temp_file"
        fi
    done < "$markdown_file"

    # Replace the original markdown file with the modified content
    mv "$temp_file" "$markdown_file"
    echo "Updated $markdown_file."
done

echo "Processing complete."
