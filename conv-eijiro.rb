#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

current = nil
File.open('EIJIRO/EIJI-1441.TXT', 'r:CP932:UTF-8') do |file|
  file.each_line do |line|
    line.chomp!
    line.gsub!('\\', '¥')
    line.gsub!('<', '&lt;')
    line.gsub!('>', '&gt;')
    line.gsub!('〔', '（')
    line.gsub!('〕', '）')
    item, desc = line.split(' : ', 2)
    item =~ /^■(.+?)(?: +\{([^{}]+)\})?$/
    entry = $1
    pos = $2
    next if desc == ''
    desc2, *examples = desc.split('■・')
    examples.map! do |ex|
      ex.split('◆')
    end
    desc3, note = desc2.split('◆')
    desc3.gsub!(/｛.+?｝/, '')
    note.gsub!(/｛.+?｝/, '') if note

    content = []
    content << desc3
    content << "<span size=\"x-small\">※#{note}</span>" if note
    examples.each do |ex, ex_note|
      content << "<span size=\"small\">• #{ex}</span>"
      content << "<span size=\"small\"><span color=\"#FFFFFF00\">• </span>#{ex_note}</span>" if ex_note
    end

    if !current
      # replace
      current = {
        entry: entry,
        contents: [[pos, content]]
      }
    elsif current[:entry] == entry
      # append
      current[:contents] << [pos, content]
    else
      # output
      print("#{current[:entry]}\t")
      lines = []
      current[:contents].each do |pos, content|
        if pos
          lines << "<span weight=\"bold\">〔#{pos}〕</span>#{content[0]}" if pos
          content[1..-1].each do |c|
            lines << "\t#{c}"
          end
        else
          content.each do |c|
            lines << "#{c}"
          end
        end
      end
      puts(lines.join('\n'))
      # replace
      current = {
        entry: entry,
        contents: [[pos, content]]
      }
    end
  end
end
