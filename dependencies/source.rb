# Usage:
#   fill in your filenames and syntax styles.  your files should be in src
#   your output png's will show up in img
# 
require 'FileUtils'

class Highlight
  def initialize()
    @separator = Config::CONFIG['host_os'] == "mswin32" ? '\\\\' : '/'
  end

  def highlight_to_svg(src_file, svg_file, opts)
    options = opts.map { |h| "--#{h[0].to_s.tr('_', '-')}=\"#{h[1]}\"" }.join(" ")
    system("highlight < \"#{src_file.tr('/', @separator)}\" > \"#{svg_file.tr('/', @separator)}\" --svg #{options}")

    # merge stylesheet into the SVG
    svg = File.open(svg_file).readlines()
    css = File.open("highlight.css").readlines()

    svg.insert(4, "<style>")
    svg.insert(5, "</style>")
    svg.insert(5, css)
    svg.flatten!
    
    code_height = (File.open(src_file) { |src| src.readlines() }).length*opts[:font_size]+20
    code_width = (File.open(src_file) { |src| src.readlines() }).map { |line| line.length}.max*(opts[:font_size]*2/3)

    # make the line spacing a little closer
    y_start = [10, ((opts[:height ]- code_height)/2)].max
    x_start = [10, ((opts[:width ]- code_width)/2)].max
    index = -1
    svg.each do |line| 
      if /.*text.*(y=\")([0-9]+)(\")/.match(line)
        index = index+1
        line.gsub!(/(.*text.*y=\")([0-9]+)(\")/, '\1' + (y_start + (index*opts[:font_size])).to_s + '\3')
        line.gsub!(/(.*text.*x=\")([0-9]+)(\")/, '\1' + x_start.to_s + '\3')
      end
    end
    File.open(svg_file, "w") do |f|
      svg.each {|line| f.write(line)}
      f.close
    end
  end
end

class Inkscape
  def initialize()
    @inkscape_executable = Config::CONFIG['host_os'] == "mswin32" ? 'inkscapec' : '/Applications/Inkscape.app/Contents/Resources/bin/inkscape'
  end

  def convert_svg_to_png(svg_file, png_file)
    # convert the SVG to a PNG for use in powerpoint
    system("#{@inkscape_executable} --export-png=#{png_file} #{svg_file}")
  end
end

default = {
  :syntax => "cs",
  :width => 1024,
  :height => 768,
  :style => "ide-msvs2008",
  :font => "Lucida Console",
  :font_size => 24 }

inkscape = Inkscape.new
highlight = Highlight.new

Dir.
  glob("src/*.*").
  map { |file| {:filename => File.basename(file), :syntax => File.extname(file).tr(".", "")} }.
  each do |f|
    src_file = File.expand_path("src/#{f[:filename]}")
    svg_file = File.expand_path("#{f[:filename]}.svg")
    png_file = File.expand_path("img/#{f[:filename]}.png")

    opts = default.merge(f)
    opts.delete(:filename)

    highlight.highlight_to_svg(src_file, svg_file, opts)
    inkscape.convert_svg_to_png(svg_file, png_file)
  end

begin
  FileUtils.rm Dir.glob('*.svg')
  File.delete("highlight.css")
rescue
  puts "Couldn't delete"
end
