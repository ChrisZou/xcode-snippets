#!/usr/bin/env ruby
#

#All the files in current directory
files = Dir["*"]

#Remove ruby file out of the array
files.each do |file|
    files.delete(file) if file.end_with?(".rb")
end

#Get the text from a xml element "<string>text</string>"
def get_text(str)
    return str.strip.sub("<string>", "").sub("</string>", "").strip
end

#Get new file name from the snippets content using prefix and title
def get_file_name(file)
    content = File.read(file)
    lines = content.split("\n")
    prefix = ""
    title = ""
    for i in 1...lines.length
        if lines[i].include?("IDECodeSnippetCompletionPrefix") 
            prefix = get_text(lines[i+1])       
        end

        if lines[i].include?("IDECodeSnippetTitle")
            title =  get_text(lines[i+1])
            title.downcase!
            title.gsub!(", ", "_")
            title.gsub!(" ", "_");
            title.gsub!(",", "_")
        end
    end
    return "#{prefix}-#{title}.codesnippet";
end

files.each do |file|
    new_name = get_file_name(file)
    puts "Rename #{file} to #{new_name}"
    File.rename(file, new_name)
end
