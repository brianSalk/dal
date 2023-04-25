# /bin/bash

# if ~/.bash_functions does not exist, create it
DAL="$HOME/.dal"
BASH_FUNCTIONS="$HOME/.bash_functions"
if [[ ! -e "${BASH_FUNCTIONS}" ]]
then
	cat dal.sh > "${BASH_FUNCTIONS}"
	echo -e "# CREATED BY DAL>>>>>>>\n. ${BASH_FUNCTIONS}\n #<<<<<<<CREATE BY DAL"
	echo created new file ~/.bash_functions and sourced the file in ~/.bashrc

else
	cat dal.sh >> "${BASH_FUNCTIONS}"
	echo appended dal function to ${BASH_FUNCTIONS}
fi
if [[ -e "${DAL}" ]]
then
	while [[ -e "${DAL}" ]]
	do
		echo >&2 file "${DAL}" already exists
		read -p "enter a filename to store your aliases in " DAL
	done
	touch "$HOME/${DAL}"
else
	touch "${DAL}"
fi
echo >&2 created file "${DAL}"
# source .bash_functions to activate dal
. "${BASH_FUNCTIONS}"
&> /dev/null dal
if [[ $? -eq 0 ]]
then
	echo >&2 dal successfully configured.  restart your terminal and run: dal '-h' to veiw help options
else
	echo >&2 something went wrong, dal is not setup.
fi

