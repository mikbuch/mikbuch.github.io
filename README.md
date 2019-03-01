## mikbuch's page based on White Paper

White Paper is a Jekyll theme -- https://github.com/vinitkumar/white-paper

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

OSX:
```bash
brew install ruby
```

### Setup Jekyll environment

`--user-install` means that it will not be installed system-wide. Then also the appropriate directory has to be added to the path, see commands block below.
```bash
gem install jekyll bundler --user-install
bundle install
```

Add ditectory with local gems to PATH (in )~/.bashrc or ~/.zshrc):
```bash
echo ' export PATH=/Users/Bacchus/.gem/ruby/2.3.0/bin:$PATH' >> ~/.zshrc
```

### Run server

In order to develop it locally use this command:
```bash
bundle exec jekyll serve
```

### Troubleshooting

#### Packages vulnerabilities

Update node packages:
```bash
sudo npm audit fix
```
