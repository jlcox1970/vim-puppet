define vim_puppet::setup (
  $user_name = $name,

){
  $home = "home_${user_name}"
  $home_path = inline_template("<%= scope.lookupvar('::$home') %>")
  $vim_dir = "${home_path}/.vim/"
  $vimrc   = "${home_path}/.vimrc"
  Exec {
    path => '/bin:/usr/bin',
  }
  exec {"$user_name mkdir for vim":
    command => "mkdir -p ${vim_dir}/autoload ${vim_dir}/bundle",
  } ->
  file {"$home_path/.vimrc":
    ensure => file,
    owner  => $user_name,
    group  => $user_name,
  } ->
  exec {"$user_name load pathogen":
    command => "curl -LSso ${vim_dir}/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim",
  } ->
  file_line {"$user_name execute pathogen#infect()":
    line => 'execute pathogen#infect()',
    path => $vimrc
  } ->
  file_line {"$user_name syntax on":
    line => 'syntax on',
    path => $vimrc
  } ->
  file_line {"$user_name filetype plugin indent on":
    line =>  'filetype plugin indent on',
    path => $vimrc
  } ->
  exec {"$user_name update vim-puppet":
    cwd     => "${vim_dir}/bundle/puppet",
    command => "git pull",
    onlyif  => "test -d ${vim_dir}/bundle/puppet/.git",
  } ->
  exec {"$user_name install vim-puppet":
    cwd     => "${vim_dir}/bundle",
    command => "git clone git://github.com/rodjek/vim-puppet.git ${vim_dir}/bundle/puppet",
    onlyif  => "test ! -d ${vim_dir}/bundle/puppet/.git",
  } ->
  exec {"$user_name update tabular":
    cwd     => "${vim_dir}/bundle/tabular",
    command => "git pull",
    onlyif  => "test -d ${vim_dir}/bundle/tabular/.git",
  } ->
  exec {"$user_name install tabular":
    cwd     => "${vim_dir}/bundle",
    command => "git clone git://github.com/godlygeek/tabular.git",
    onlyif  => "test ! -d ${vim_dir}/bundle/tabular/.git",
  } ->
  exec {"$user_name setup perms on .vim" :
    cwd     => $home_path,
    command => "chown ${user_name}.${user_name} ${vim_dir} -R",
  }
}
