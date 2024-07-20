# Assignment 6: Linux File Management and System Analysis
# Author: Paul Jackson

# TASK 1: DIRECTORY AND FILE MANAGEMENT

# a. Create a directory named "project"
mkdir project
# Explanation: 'mkdir' is used to create directories.

# b. Inside the "project" directory, create two subdirectories: "reports" and "resources"
cd project
mkdir reports resources
# Explanation: first we change directories into the "project" directory, then 'mkdir' creates the specified directories.

# c. Create three files inside the "reports" directory: "progress.txt", "budget.txt", and "summary.txt"
cd reports
touch progress.txt budget.txt summary.txt
# Explanation: 'touch' craetes empty files with the given filenames.

# d. Move "budget.txt" from the "reports" directory to the "resources" directory
mv budget.txt ../resources/
# Explanation: 'mv' moves a specified file.

# e. Delete the "summary.txt" file from the "reports directory"
rm summary.txt
# Explanation: 'rm' removes a specified file.

# TASK 2: System Analysis

# Determine the Linux distribution and version
cat /etc/os-release
# Explanation: Using 'cat' to display info about the distribution and version.

# Display the kernel version & architecture
uname -r
uname -m
# Explanation: 'uname -r' prints the kernel version, and 'uname -m' prints the architecture.

# Check the available disk space & memory usage
df -h
free -h
# Explanation: 'df -h' displays the disk space, 'free -h' displays the memory usage.