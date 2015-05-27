def init
  options.files.each{|file|
    if file.filename.end_with?('.rspec') then
      document = REXML::Document.new(File.new(file.filename))

      if title = document.elements["html/head/title"] then
        file.attributes[:title] = title.text
      end
      if body = document.elements["html/body"] then
        file.contents = body.to_s
      end
    end
  }
  super
end
