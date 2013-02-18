name "preparation"
description "Create directories, ensure system packages are installed before build"

build do
  block do
    %w{embedded/lib embedded/bin bin}.each do |dir|
      FileUtils.mkdir_p(File.expand_path(dir, install_dir))
    end
  end
  block do
    got_all_packages = true
    missing_packages = Array.new
    %w{openssl libssl-dev zlib1g zlib1g-dev libyaml-0-2 libyaml-dev build-essential libaugeas0 libaugeas-dev pkg-config libreadline6 libreadline6-dev libncurses5 libncurses-dev}.each do |package|
      unless system("dpkg -s #{package} >/dev/null 2>&1")
        got_all_packages = false
        puts "Missing package #{package}"
        missing_packages.push(package)
      end
    end
    fail "### Required packages missing: #{missing_packages.join(", ")}. Install them with apt-get <packagename> ###" unless got_all_packages   
  end
end
