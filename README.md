# dal
Directory ALiaser.  Navigate BASH faster then ever with a few simple commands.  
create aliases for your directories so you can get more done with fewer `cd` commands.
# setup
once you cloned this repo, simply run the setup.sh script  

this will do the following:  
* if you already have a file called `~/.bash_functions`, dal will be appended to that file, else `~/.bash_functions` will be created and sourced in your `.bashrc`  
* dal will be appended to your `~/.bash_functions` file  
* a file with the default name `.dal` will be added to your home directory
After running `setup.sh`, restart your terminal and run `dal --help` for instructions  
## recomended configurations
once **dal** is setup, I recommend adding the following alias:  
```
alias 'CD=dal goto'
```
this will allow you to do the following  
```
dal add my_dir /very/long/path/do/my_dir
CD my_dir
```
