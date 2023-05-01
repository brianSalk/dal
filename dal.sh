#!/usr/bin/env bash

# dal is a function which allows you to quickly navagate your filesystem by creating aliases for directories.
#+add adds a new alias and path to a file
dal() {
	local ALIAS=''
	local _PATH=''
	if [[ $# -eq 0 ]]
	then
			echo dal args:
			echo add: add a new alias or path
			echo all: prints all paths, accepts an optional regex
			echo del: delete an alias
		   	echo goto: goto path associated with an alias 	
			echo path: prints the path with the alias
			echo update: update the path associated with an alias
			return
	fi
	# first check which command is being used
	#+ commands are: goto, print, add, del, all, update
	case $1 in
		--help)
			echo dal args:
			echo add: add a new alias or path
			echo all: prints all paths, accepts an optional regex
			echo del: delete an alias
		   	echo goto: goto path associated with an alias 	
			echo path: prints the path with the alias
			echo update: update the path associated with an alias
			;;
		add)
			if [ $# -eq 3 ]; then
				_PATH="$3"
			elif [ $# -eq 2 ]; then
				_PATH=$(pwd)
			else
				echo "dal add requires one or two arguments in the form:" >&2
				echo "dal add <alias> [<path>...]" >&2
				return 
			fi
			ALIAS="$2"
			# search ~/.dal to see if the argument exists in the file
			#+if it does, do nothing
			#+if not, append alias with path to file
			local IS_THERE=""
			IS_THERE=$(awk -v alias="${ALIAS}" 'match($1,"^" alias "$" )' "${HOME}"/DAL_FILE)
			if [ -z "${IS_THERE}" ]; then
				echo "${ALIAS} ${_PATH}" >> "${HOME}"/DAL_FILE
			else
				echo "${ALIAS} already assigned ${_PATH}, use 'update' command to reassign" >&2
			fi
			;;
		all)
			if [ $# -eq 1 ]; then
				cat "${HOME}"/DAL_FILE
			elif [ $# -eq 2 ]; then
				awk -v rx="$2" '$1 ~ rx' "${HOME}"/DAL_FILE
			else
				echo "dal all requires zero or one argument(s) in the form of:" >&2
				echo "dal all [<regex>]"
				return 1
			fi
			;;
		del)
			if [ $# -lt 2 ]; then
				echo "dal del requires one or more arguments in the form of:" >&2
				echo "dal del <alias1 [<alias2>...]>" >&2
				return
			fi
			# if the alias exists remove it, else nothing
			while [ ${2+"x"} ]
			do
				ALIAS="$2"
				sed -ni "/^${ALIAS} .*/!p" "${HOME}"/DAL_FILE
				shift
			done
			;;
		goto)
			if [ $# -ne 2 ]; then
				echo "dal goto requires exactly one argument in the form of:" >&2
				echo "dal goto <alias>" >&2
				return
			fi
			# find alias in file, get the line number, 
			# use line number to get the path.
			# cd to the path.
			ALIAS="$2"
			_PATH=$(awk -v alias="^${ALIAS}$" '$1 ~ alias{print $0; exit}' "${HOME}"/DAL_FILE)
			_PATH=$(cut -d' ' -f1 --complement <<< "$_PATH")
			if [ -n "${_PATH}" ]; then
				cd "${_PATH}" || exit 1
			else
				echo "$ALIAS not found, add it with:" >&2
				echo "dal add $ALIAS <path>" >&2
			fi
			;;
		path)
			if [ $# -ne 2 ]; then
				echo "dal path takes requires one argument in the form of:" >&2
				echo "dal path <alias>" >&2
				return
			fi
			ALIAS="$2"
			_PATH=""
			# print the path associated with the alias if one exists
			_PATH=$(awk -v alias="${ALIAS}" 'match($1, "^" alias "$")' "${HOME}"/DAL_FILE)
			cut -d' ' -f1 --complement <<< "${_PATH}"
			;;
		update)
			if [ $# -eq 2 ]; then
				_PATH="$(pwd)"
			elif [ $# -eq 3 ]; then
				_PATH="$3"
			else 
				echo "dal update requires 1 or 2 arguments in the form of:" >&2
				echo "dal update <alias> [<path>]" >&2
				return
			fi
			# update an alias if one exists, else apppend
			ALIAS="$2"
			# remove line containing alias
			sed -ni "/^${ALIAS} .*$/!p" "${HOME}"/DAL_FILE
			echo "${ALIAS} ${_PATH}" >> "${HOME}"/DAL_FILE
			;;
		*)
			echo "$1: invalid argument for dal"
			return 1
			;;
	esac
}
