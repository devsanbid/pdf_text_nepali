#!/usr/bin/bash

input_pdf="$1"
output_prefix="$2"

if [ -z "$input_pdf" ]; then
  echo "Please enter your first arguments (pdf)"
  exit 1;
fi

if [ -z "$output_prefix" ]; then
  echo "Please enter your second arguments (output prefix)"
  exit 1
fi


if ! command -v pdftoppm &> /dev/null; then 
  echo "pdftoppm is not installed"
  exit 1;
fi

if  ! command -v tesseract &> /dev/null; then 
  echo "tesseract is not installed"
  exit 1;
fi

echo "Converting.........."
text_file="$output_prefix.txt"  # Output text file with all pages combined
echo "" > "$text_file"  # Clear any existing content
# convert pdf to image
pdftoppm -png "$input_pdf" "$output_prefix"

# text convert
for image in "${output_prefix}"*.png; do
  tesseract -l nep "$image" "$image"
  cat "${image}".txt >> "$text_file"
  rm -rf "${image}".txt
  rm -rf "$image"
done


