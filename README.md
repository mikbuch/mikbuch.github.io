## mikbuch's page based on White Paper theme

White Paper is a Jekyll theme -- https://github.com/vinitkumar/white-paper

Given that all is properly installed and configured, to run the server use the command:
```bash
bundle exec jekyll serve
```
Otherwise, you have to go trough all the steps below.


### Install ruby:

Source: https://www.ruby-lang.org/en/documentation/installation/

Debian/Ubuntu
```bash
sudo apt-get install ruby-full
```

ArchLinux
```bash
sudo pacman -S ruby
```

macOS:
```bash
brew install ruby
```

### Setup Jekyll environment

`--user-install` means that it will not be installed system-wide. Then also the appropriate directory has to be added to the path, see commands block below.
```bash
gem install jekyll bundler --user-install
bundle install
```

Add ditectory with local gems to PATH (in ~/.bashrc or ~/.zshrc):
```bash
echo 'export PATH=/Users/$USER/.gem/ruby/2.6.0/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```
where `$USER` is your user name for which bundle[r] was installed.

### Run server

In order to develop it locally use this command:
```bash
bundle exec jekyll serve
```
Note: be sure to run it from the main project directory, not for example from "_posts".

### Generate CSS
```bash
sudo npm install -g grunt-cli
npm install
grunt
```

### Troubleshooting

#### Packages vulnerabilities

Update node packages:
```bash
sudo npm audit fix
```

#### Mind which Ruby version you have installed

Depending on the Ruby version you have install you may need to use `bundle` different directory, e.g.,:
```bash
echo 'export PATH=/Users/$USER/.gem/ruby/2.6.0/bin:$PATH' >> ~/.zshrc
```
or:
```bash
echo 'export PATH=/Users/$USER/.gem/ruby/2.3.0/bin:$PATH' >> ~/.zshrc
```

Otherwise you will get error like (macOS):
```bash
zsh: /Users/$USER/.gem/ruby/2.3.0/bin/bundle: bad interpreter: /System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby: no such file or directory
```

To determine which Ruby version you have installed run:
```bash
ls /System/Library/Frameworks/Ruby.framework/Versions/
```