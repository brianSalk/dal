# dal
Directory ALiaser.  Navigate BASH faster then ever with a few simple commands.
# setup
once you cloned this repo, run:  
```
chmod +x setup.sh
./setup.sh
```
this will do the following:  
* if you already have a file called `~/.bash_functions`, dal will be appended to that file, else `~/.bash_functions` will be created and sourced in your `.bashrc`  
* dal will be appended to your `~/.bash_functions` file  
* a file with the default name `.dal` will be added to your home directory
After running `setup.sh`, restart your terminal and run `dal --help` for instructions  
