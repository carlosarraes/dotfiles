. "$HOME/.cargo/env"

export FZF_DEFAULT_OPTS="--height 41% --layout=reverse --border"
export FZF_DEFAULT_COMMAND="fd --type f"
export PATH=$PATH:$HOME/scripts
export WLR_NO_HARDWARE_CURSORS=1

export PATH=$PATH:~/go/bin

export EDITOR='nvim'
export BROWSER="firefox"
export VIDEO="mpv"
export IMAGE="sxiv"
export OPENER="xdg-open"

export LF_COLORS="
ln=01;36:\
or=31;01:\
tw=34:\
ow=34:\
st=01;34:\
di=01;34:\
pi=33:\
so=01;35:\
bd=33;01:\
cd=33;01:\
su=01;32:\
sg=01;32:\
ex=01;31:\
fi=00:\
*.tar=00;93:\
*.tgz=00;93:\
*.arc=00;93:\
*.arj=00;93:\
*.taz=00;93:\
*.lha=00;93:\
*.lz4=00;93:\
*.lzh=00;93:\
*.lzma=00;93:\
*.tlz=00;93:\
*.txz=00;93:\
*.tzo=00;93:\
*.t7z=00;93:\
*.zip=00;93:\
*.z=00;93:\
*.dz=00;93:\
*.gz=00;93:\
*.lrz=00;93:\
*.lz=00;93:\
*.lzo=00;93:\
*.xz=00;93:\
*.zst=00;93:\
*.tzst=00;93:\
*.bz2=00;93:\
*.bz=00;93:\
*.tbz=00;93:\
*.tbz2=00;93:\
*.tz=00;93:\
*.deb=00;93:\
*.rpm=00;93:\
*.jar=00;93:\
*.war=00;93:\
*.ear=00;93:\
*.sar=00;93:\
*.rar=00;93:\
*.alz=00;93:\
*.ace=00;93:\
*.zoo=00;93:\
*.cpio=00;93:\
*.7z=00;93:\
*.rz=00;93:\
*.cab=00;93:\
*.wim=00;93:\
*.swm=00;93:\
*.dwm=00;93:\
*.esd=00;93:\
*.jpg=01;33:\
*.jpeg=01;33:\
*.mjpg=01;33:\
*.mjpeg=01;33:\
*.gif=01;33:\
*.bmp=01;33:\
*.pbm=01;33:\
*.pgm=01;33:\
*.ppm=01;33:\
*.tga=01;33:\
*.xbm=01;33:\
*.xpm=01;33:\
*.tif=01;33:\
*.tiff=01;33:\
*.png=01;33:\
*.svg=01;33:\
*.svgz=01;33:\
*.mng=01;33:\
*.pcx=01;33:\
*.mov=01;33:\
*.mpg=01;33:\
*.mpeg=01;33:\
*.m2v=01;33:\
*.mkv=01;33:\
*.webm=01;33:\
*.ogm=01;33:\
*.mp4=01;33:\
*.m4v=01;33:\
*.mp4v=01;33:\
*.vob=01;33:\
*.qt=01;33:\
*.nuv=01;33:\
*.wmv=01;33:\
*.asf=01;33:\
*.rm=01;33:\
*.rmvb=01;33:\
*.flc=01;33:\
*.avi=01;33:\
*.fli=01;33:\
*.flv=01;33:\
*.gl=01;33:\
*.dl=01;33:\
*.xcf=01;33:\
*.xwd=01;33:\
*.yuv=01;33:\
*.cgm=01;33:\
*.emf=01;33:\
*.ogv=01;33:\
*.ogx=01;33:\
*.aac=00;35:\
*.au=00;35:\
*.flac=00;35:\
*.m4a=00;35:\
*.mid=00;35:\
*.midi=00;35:\
*.mka=00;35:\
*.mp3=00;35:\
*.mpc=00;35:\
*.ogg=00;35:\
*.ra=00;35:\
*.wav=00;35:\
*.oga=00;35:\
*.opus=00;35:\
*.spx=00;35:\
*.xspf=00;35:\
"

export LF_ICONS="
tw=:\
st=:\
ow=:\
dt=:\
di=:\
fi=:\
ln=:\
or=:\
ex=:\
*.styl=:\
*.sass=:\
*.scss=:\
*.htm=:\
*.html=:\
*.slim=:\
*.haml=:\
*.ejs=:\
*.css=:\
*.less=:\
*.md=:\
*.mdx=:\
*.markdown=:\
*.rmd=:\
*.json=:\
*.webmanifest=:\
*.js=:\
*.mjs=:\
*.jsx=:\
*.rb=:\
*.gemspec=:\
*.rake=:\
*.php=:\
*.py=:\
*.pyc=:\
*.pyo=:\
*.pyd=:\
*.coffee=:\
*.mustache=:\
*.hbs=:\
*.conf=:\
*.ini=:\
*.yml=:\
*.yaml=:\
*.toml=:\
*.bat=:\
*.mk=:\
*.jpg=:\
*.jpeg=:\
*.bmp=:\
*.png=:\
*.webp=:\
*.gif=:\
*.ico=:\
*.twig=:\
*.cpp=:\
*.c++=:\
*.cxx=:\
*.cc=:\
*.cp=:\
*.c=:\
*.cs=:\
*.h=:\
*.hh=:\
*.hpp=:\
*.hxx=:\
*.hs=:\
*.lhs=:\
*.nix=:\
*.lua=:\
*.java=:\
*.sh=:\
*.fish=:\
*.bash=:\
*.zsh=:\
*.ksh=:\
*.csh=:\
*.awk=:\
*.ps1=:\
*.ml=λ:\
*.mli=λ:\
*.diff=:\
*.db=:\
*.sql=:\
*.dump=:\
*.clj=:\
*.cljc=:\
*.cljs=:\
*.edn=:\
*.scala=:\
*.go=:\
*.dart=:\
*.xul=:\
*.sln=:\
*.suo=:\
*.pl=:\
*.pm=:\
*.t=:\
*.rss=:\
'*.f#'=:\
*.fsscript=:\
*.fsx=:\
*.fs=:\
*.fsi=:\
*.rs=:\
*.rlib=:\
*.d=:\
*.erl=:\
*.hrl=:\
*.ex=:\
*.exs=:\
*.eex=:\
*.leex=:\
*.heex=:\
*.vim=:\
*.ai=:\
*.psd=:\
*.psb=:\
*.ts=:\
*.tsx=:\
*.jl=:\
*.pp=:\
*.vue=﵂:\
*.elm=:\
*.swift=:\
*.xcplayground=:\
*.tex=ﭨ:\
*.r=ﳒ:\
*.rproj=鉶:\
*.sol=ﲹ:\
*.pem=:\
*gruntfile.coffee=:\
*gruntfile.js=:\
*gruntfile.ls=:\
*gulpfile.coffee=:\
*gulpfile.js=:\
*gulpfile.ls=:\
*mix.lock=:\
*dropbox=:\
*.ds_store=:\
*.gitconfig=:\
*.gitignore=:\
*.gitattributes=:\
*.gitlab-ci.yml=:\
*.bashrc=:\
*.zshrc=:\
*.zshenv=:\
*.zprofile=:\
*.vimrc=:\
*.gvimrc=:\
*_vimrc=:\
*_gvimrc=:\
*.bashprofile=:\
*favicon.ico=:\
*license=:\
*node_modules=:\
*react.jsx=:\
*procfile=:\
*dockerfile=:\
*docker-compose.yml=:\
*rakefile=:\
*config.ru=:\
*gemfile=:\
*makefile=:\
*cmakelists.txt=:\
*robots.txt=ﮧ:\
*Gruntfile.coffee=:\
*Gruntfile.js=:\
*Gruntfile.ls=:\
*Gulpfile.coffee=:\
*Gulpfile.js=:\
*Gulpfile.ls=:\
*Dropbox=:\
*.DS_Store=:\
*LICENSE=:\
*React.jsx=:\
*Procfile=:\
*Dockerfile=:\
*Docker-compose.yml=:\
*Rakefile=:\
*Gemfile=:\
*Makefile=:\
*CMakeLists.txt=:\
*jquery.min.js=:\
*angular.min.js=:\
*backbone.min.js=:\
*require.min.js=:\
*materialize.min.js=:\
*materialize.min.css=:\
*mootools.min.js=:\
*vimrc=:\
Vagrantfile=:\
*.tar=:\
*.tgz=:\
*.arc=:\
*.arj=:\
*.taz=:\
*.lha=:\
*.lz4=:\
*.lzh=:\
*.lzma=:\
*.tlz=:\
*.txz=:\
*.tzo=:\
*.t7z=:\
*.zip=:\
*.z=:\
*.dz=:\
*.gz=:\
*.lrz=:\
*.lz=:\
*.lzo=:\
*.xz=:\
*.zst=:\
*.tzst=:\
*.bz2=:\
*.bz=:\
*.tbz=:\
*.tbz2=:\
*.tz=:\
*.deb=:\
*.rpm=:\
*.jar=:\
*.war=:\
*.ear=:\
*.sar=:\
*.rar=:\
*.alz=:\
*.ace=:\
*.zoo=:\
*.cpio=:\
*.7z=:\
*.rz=:\
*.cab=:\
*.wim=:\
*.swm=:\
*.dwm=:\
*.esd=:\
*.jpg=:\
*.jpeg=:\
*.mjpg=:\
*.mjpeg=:\
*.gif=:\
*.bmp=:\
*.pbm=:\
*.pgm=:\
*.ppm=:\
*.tga=:\
*.xbm=:\
*.xpm=:\
*.tif=:\
*.tiff=:\
*.png=:\
*.svg=:\
*.svgz=:\
*.mng=:\
*.pcx=:\
*.mov=:\
*.mpg=:\
*.mpeg=:\
*.m2v=:\
*.mkv=:\
*.webm=:\
*.ogm=:\
*.mp4=:\
*.m4v=:\
*.mp4v=:\
*.vob=:\
*.qt=:\
*.nuv=:\
*.wmv=:\
*.asf=:\
*.rm=:\
*.rmvb=:\
*.flc=:\
*.avi=:\
*.fli=:\
*.flv=:\
*.gl=:\
*.dl=:\
*.xcf=:\
*.xwd=:\
*.yuv=:\
*.cgm=:\
*.emf=:\
*.ogv=:\
*.ogx=:\
*.aac=:\
*.au=:\
*.flac=:\
*.m4a=:\
*.mid=:\
*.midi=:\
*.mka=:\
*.mp3=:\
*.mpc=:\
*.ogg=:\
*.ra=:\
*.wav=:\
*.oga=:\
*.opus=:\
*.spx=:\
*.xspf=:\
*.pdf=:\
*.odt=:\
*.docx=:\
*.doc=:\
*.xlsx=:\
*.wiki=:\
"
