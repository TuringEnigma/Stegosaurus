#!/bin/bash

# Get the directory of the script
script_dir=$(dirname "$(readlink -f "$0")")

# Create a temporary directory in the script directory
temp_dir=$(mktemp -d -p "$script_dir")

# Function to remove temporary directory and its contents
cleanup() {
  rm -rf "$temp_dir"
}

# Function to display message in bold red letters
print_bold_red() {
  printf "\e[1;31m%s\e[0m\n" "$1"
}

# Prompt user to select the steganographic image file
read -rp "Enter the path to the steganographic image file: " steganographic_image

# Run the command to recover the secret from the steganographic image
./lsb_image_stego.py -R -c "$steganographic_image" -o "$temp_dir/output_file"

# Check if the command was successful
if [[ $? -eq 0 ]]; then
  # Move the output file to the temporary directory
  mv "$temp_dir/output_file" "$temp_dir/"
  echo "Recovered secret saved as $temp_dir/output_file"

  # Display message in bold red letters
  print_bold_red "Ready to purge. Do you want to delete the temporary directory? (yes/no): "

  # Prompt user to confirm deletion of temporary directory
  read -rp "" response
  if [[ "$response" == "yes" || "$response" == "y" ]]; then
    cleanup
    echo "Temporary directory purged."
  else
    echo "Temporary directory preserved."
  fi
else
  echo "An error occurred during the process."
  echo "Temporary directory: $temp_dir"
fi
