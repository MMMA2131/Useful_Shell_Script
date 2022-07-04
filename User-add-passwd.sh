#!/bin/bash

# Make sure the script is being executed with superuser privileges.

UID_A="$(id -u)"
if [[ "${UID_A}" -ne 0 ]]
then
        echo "This script can be executed only with Root user"
        exit 1
fi


# If the user doesn't supply at least one argument, then give them help.

PARAMEETER="${#}"
if [[ "${PARAMEETER}" -lt 1 ]]
then
        echo "Please enter the UserName along with script"
        exit 1
fi

# The first parameter is the user name.

USER_NAME="${1}"

# The rest of the parameters are for the account comments.
shift
COMMENT="${@}"

# Generate a password.

PASSWORD="$(date +%s%n  | sha256sum | head -c48)"

# Create the user with the password.

useradd -c "${COMMENT}" -m "${USER_NAME}"

# Check to see if the useradd command succeeded.

if [[ "${?}" -ne 0 ]]
then
        echo "User was not added successfully"
        exit 1
fi

# Set the password.

echo "${PASSWORD}" | passwd --stdin "${USER_NAME}"

# Check to see if the passwd command succeeded.

if [[ "${?}" -ne 0 ]]
then
        echo "Password was not set successfully"
        exit 1
fi


# Force password change on first login.

passwd -e "${USER_NAME}"

# Display the username, password, and the host where the user was created.
echo "This is your UserName: ${USER_NAME}"
echo
echo "This is your Password: ${PASSWORD}"
echo
echo "This account was created for this host: $(hostname)"
