# Usage:
#   fill in your filenames and syntax styles.  your files should be in src
#   your output png's will show up in img
# 

files = [
  {:filename => "ServiceLocator.cs"},
  {:filename => "NoInjection.cs"},
  {:filename => "ConstructorInjection.cs"},
  {:filename => "PoorManDI.cs"},
  {:filename => "ManualInjection.cs"},
  {:filename => "Container.cs"},
  {:filename => "ContainerAutowire.cs"},
  {:filename => "Singleton.cs"},
  {:filename => "Intercept.cs"},
  {:filename => "PropertyInjection.cs"}]

default = {
  :syntax => "cs",
  :width => 1024,
  :height => 768,
  :style => "ide-msvs2008",
  :font => "\"Lucida Console\"",
  :font_size => 24 }

files.each do |f|
  src_file = "src/#{f[:filename]}"
  svg_file = "#{f[:filename]}.svg"
  png_file = "img/#{f[:filename]}.png"

  syntax = f[:syntax] || default[:syntax]
  style = f[:style] || default[:style]
  font = f[:font] || default[:font]
  font_size = f[:font_size] || default[:font_size]

  height = f[:height] || default[:height] 
  width = f[:width] || default[:width]

  # highlight the file into an SVG
  system("highlight < #{src_file} > #{svg_file} --svg --syntax=#{syntax} --style=#{style} --font=#{font} --font-size=#{font_size} --height=#{height.to_s} --width=#{width.to_s}")

  # merge stylesheet into the SVG
  svg = File.open(svg_file).readlines()
  css = File.open("highlight.css").readlines()

  svg.insert(4, "<style>")
  svg.insert(5, "</style>")
  svg.insert(5, css)
  svg.flatten!
  
  code_height = (File.open(src_file) { |src| src.readlines() }).length*font_size+20
  code_width = (File.open(src_file) { |src| src.readlines() }).map { |line| line.length}.max*(font_size*2/3)

  # make the line spacing a little closer
  y_start = ((height - code_height)/2)
  x_start = ((width - code_width)/2)
  index = -1
  svg.each do |line| 
    if /.*text.*(y=\")([0-9]+)(\")/.match(line)
      index = index+1
      line.gsub!(/(.*text.*y=\")([0-9]+)(\")/, '\1' + (y_start + (index*font_size)).to_s + '\3')
      line.gsub!(/(.*text.*x=\")([0-9]+)(\")/, '\1' + x_start.to_s + '\3')
    end
  end
  File.open(svg_file, "w") {|f| svg.each {|line| f.write(line)}}


  # convert the SVG to a PNG for use in powerpoint
  system("/Applications/Inkscape.app/Contents/Resources/bin/inkscape --export-png=#{png_file} #{svg_file}")

  File.delete(svg_file)
  File.delete("highlight.css")
end
