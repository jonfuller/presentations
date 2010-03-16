# Usage:
#   fill in your filenames and syntax styles.  your files should be in src
#   your output png's will show up in img
# 

files = [
  {:filename => "ServiceLocator.cs", :syntax => "cs"},
  {:filename => "NoInjection.cs", :syntax => "cs"},
  {:filename => "ConstructorInjection.cs", :syntax => "cs"},
  {:filename => "PropertyInjection.cs", :syntax => "cs"}]

default = {
  :style => "vim",
  :font => "\"Lucida Console\"",
  :font_size => 18 }

files.each do |f|
  src_file = "src/#{f[:filename]}"
  svg_file = "#{f[:filename]}.svg"
  png_file = "img/#{f[:filename]}.png"

  syntax = f[:syntax]
  style = f[:style] || default[:style]
  font = f[:font] || default[:font]
  font_size = f[:font_size] || default[:font_size]


  height = f[:height] || (File.open(src_file) { |src| src.readlines() }).length*font_size+20
  width = f[:width] || (File.open(src_file) { |src| src.readlines() }).map { |line| line.length}.max*(font_size*2/3)

  # highlight the file into an SVG
  system("highlight < #{src_file} > #{svg_file} --svg --syntax=#{syntax} --style=#{style} --font=#{font} --font-size=#{font_size} --height=#{height.to_s} --width=#{width.to_s}")

  # merge stylesheet into the SVG
  svg = File.open(svg_file).readlines()
  css = File.open("highlight.css").readlines()

  svg.insert(4, "<style>")
  svg.insert(5, "</style>")
  svg.insert(5, css)
  svg.flatten!
  
  # make the line spacing a little closer
  index = -1
  svg.each do |line| 
    index = index+1 if /(y=\")([0-9]+)(\")/.match(line)
    line.gsub!(/(y=\")([0-9]+)(\")/, '\1' + (index*(font_size)).to_s + '\3')
  end
  File.open(svg_file, "w") {|f| svg.each {|line| f.write(line)}}


  # convert the SVG to a PNG for use in powerpoint
  system("/Applications/Inkscape.app/Contents/Resources/bin/inkscape --export-png=#{png_file} #{svg_file}")

  File.delete(svg_file)
  File.delete("highlight.css")
end

