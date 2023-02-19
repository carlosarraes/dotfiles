#!/usr/bin/env fish

if test (count $argv) -lt 2
  echo "Usage: rename_files <new_name> <start_number>"
  exit 1
end

set new_name $argv[1]
set start_number (math $argv[2] - 1)
set increment (math $start_number + 1)

# Get list of files in folder, sorted by modification time
set files (exa --time modified)

# Loop through files and rename them
for file in $files
  # Ignore directories
  if test -d $file
    continue
  end

  # Get extension of file (if any)
  set extension (echo $file | awk -F . '{if (NF>1) {print $NF}}')

  # Construct new name with increment
  set new_file "$new_name $increment"
  if test -n $extension
    set new_file "$new_file.$extension"
  end

  # Rename file
  mv $file $new_file

  # Increment counter for next file
  set increment (math $increment + 1)
end
