#!/bin/bash
#This script bellow ask user insert his/her name 
read -p "Enter your Name: " user_name
#This script bellow creates the directory with username submission_reminder_user-name 
mkdir -p submission_reminder_$user_name
#This script bellow is going to create the other subdirectories 
mkdir submission_reminder_$user_name/app submission_reminder_$user_name/modules submission_reminder_$user_name/assets  submission_reminder_$user_name/config
#This script bellow Create required files inside respective directories
touch  submission_reminder_$user_name/app/reminder.sh submission_reminder_$user_name/modules/functions.sh  submission_reminder_$user_name/assets/submissions.txt submission_reminder_$user_name/config/config.env submission_reminder_$user_name/startup.sh
#This script bellow Inserting Data into the the config.env file
cat << 'EOF' > submission_reminder_$user_name/config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF
#This script bellow Populate reminder.sh with logic to source configurations and functions
cat << 'EOF' > submission_reminder_$user_name/app/reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF
# Populate functions.sh with helper functions
cat << 'EOF' > submission_reminder_$user_name/modules/functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF
#Populate submissions.txt with a sample entry
cat << 'EOF' > submission_reminder_$user_name/assets/submissions.txt
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Gilbert, Shell Navigation, not submitted
Sheillah, Git, submitted
Karangwa, Shell Navigation, not submitted
Loise, Shell Basics, submitted
Keza, Shell Navigation, not submitted
Shema, Git, submitted
Divin, Shell Navigation, not submitted
Ally, Shell Basics, submitted
EOF
# Giving startup.sh with logic to start the application
cat << 'EOF' > submission_reminder_$user_name/startup.sh
#!/bin/bash
#This command bellow run the reminder.sh file
./app/reminder.sh
EOF

#Adding execution permission to reminder.sh functions.sh config.env and startup.sh
chmod +x submission_reminder_$user_name/app/reminder.sh submission_reminder_$user_name/modules/functions.sh submission_reminder_$user_name/config/config.env submission_reminder_$user_name/startup.sh
# Print success message
echo "Environment setup complete! Your submission reminder app is now ready."
