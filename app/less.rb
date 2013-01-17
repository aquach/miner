require 'rubygems'
require 'listen'
require 'pathname'

RENDERED_PATH = 'rendered'

path = Pathname.new(File.expand_path('.'))
Listen.to('.') do |modified, *|
  modified = modified.map { |file| Pathname.new(file).relative_path_from(path).to_s }
  modified.each do |filename|
    next if filename[RENDERED_PATH]

    ext = File.extname(filename)
    renderer = nil
    output_ext = nil
    case ext
    when '.less'
      renderer = 'lessc'
      output_ext = 'css'
    when '.haml'
      renderer = 'haml'
      output_ext = 'html'
    when '.coffee'
      renderer = 'coffee -cp'
      output_ext = 'js'
    end

    next if renderer == nil

    output = RENDERED_PATH + '/' + File.basename(filename, ext) + '.' + output_ext
    puts "Rendering #{filename} to #{output}..."
    system("#{renderer} #{filename} > #{output}")
  end
end
