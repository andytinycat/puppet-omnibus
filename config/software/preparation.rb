name "preparation"
description "the steps required to preprare the build"

build do
  block do
    %w{embedded/lib embedded/bin bin}.each do |dir|
      FileUtils.mkdir_p(File.expand_path(dir, install_dir))
    end
  end
end
