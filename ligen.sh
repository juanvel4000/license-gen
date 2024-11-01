#!/bin/bash

# Function to display an error message
function error_exit {
    dialog --msgbox "$1" 10 50
    exit 1
}

# Prompt for the copyright holder's name
name=$(dialog --inputbox "Name of the Copyright Holder" 10 50 --output-fd 1)
year=$(date +%Y)

# Confirm the input
if dialog --yesno "Is this correct?: $year (c) $name" 10 50; then
    full="$year (c) $name"
else
    # Allow user to enter a custom message
    full=$(dialog --inputbox "Enter your own copyright notice:" 10 50 --output-fd 1)
fi

# Notices
warrantyclaim="THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."

liabilityclaim="The authors are not responsible for any damage caused by the use of this software."

watermark="This Software License was Generated with LiGen. View https://github.com/juanvel4000/license-gen for more info."

modnot="Modifications to this software are permitted, provided credit is given to the original authors."

updatenot="This software may receive updates or enhancements in the future."

custom_notice="Users are encouraged to review the software’s terms and conditions."

# Options for the checklist
choices=(1 "LiGen Watermark" on
         2 "Warranty Claim" off
         3 "Liability Claim" off
         4 "Modification Notice" off
         5 "Update Notice" off
         6 "Custom Notice" off)

# Show the checklist dialog
selected_choices=$(dialog --checklist "Select Options" 15 50 6 "${choices[@]}" 3>&1 1>&2 2>&3)

# Check if the user canceled the dialog
if [ $? -eq 1 ]; then
    echo "Dialog canceled."
    exit
fi

# Initialize output variable
output=""

# Process selected options
IFS=$'\n' # Set internal field separator to handle line breaks
for choice in $selected_choices; do
    case "$choice" in
        1) output+="$watermark"$'\n' ;;
        2) output+="$warrantyclaim"$'\n' ;;
        3) output+="$liabilityclaim"$'\n' ;;
        4) output+="$modnot"$'\n' ;;
        5) output+="$updatenot"$'\n' ;;
        6) output+="$custom_notice"$'\n' ;;
    esac
done

# Prompt for output file name
outputfile=$(dialog --inputbox "Enter a name for your Output" 10 50)

# Check if the user canceled the dialog for output file name
if [ $? -eq 1 ]; then
    echo "Dialog canceled."
    exit
fi

# Write the final results to the specified output file
echo -e "$full\n$output" > "$outputfile" || error_exit "Failed to write to $outputfile."

# Inform the user
dialog --msgbox "Output written to $outputfile" 10 50
