#!/bin/bash

# Activate the virtual environment
source .venv/bin/activate  # Linux/macOS

echo -e "\n\n"

# Display ASCII art
cat dedsec

# Add a larger gap after the ASCII art
echo -e "\n\n"

# Function to read file input
read_file_input() {
    local prompt="$1"
    local file_var="$2"
    local red='\033[0;31m'
    local nc='\033[0m'  # No Color

    echo -e "${prompt} ${red}Then press Enter:${nc}"
    read -rp "" file_path
    eval "$file_var='$file_path'"
}

# Prompt user to select the cover image file
read_file_input "Drag and drop image file." cover_image

# Prompt user to select the secret file
read_file_input "Drag and drop secret file." secret_file

# Prompt user to specify the output file name
read -rp "Enter the output file name: " output_image

# Run the steganography command
./lsb_image_stego.py -H -c "$cover_image" -s "$secret_file" -o "$output_image"

# Check if the command was successful
if [[ $? -eq 0 ]]; then
  echo "Secret hidden in image saved as $output_image"
else
  echo "An error occurred during the process."
fi

# Ask if the user wants to show a file
read -rp "Would you like to show a file? (yes/no): " show_file

if [[ "$show_file" =~ ^[Yy][Ee][Ss]$ || "$show_file" =~ ^[Yy]$ ]]; then
  # Run the show.sh script
  ./show.sh
else
  # Close the terminal
  echo "Closing terminal..."
  exit
fi
