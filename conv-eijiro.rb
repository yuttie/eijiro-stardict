#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

ARGF.set_encoding('CP932:UTF-8')

def parse(line)
  line.chomp!
  line.gsub!('\\', '¥')
  line.gsub!('<', '&lt;')
  line.gsub!('>', '&gt;')
  line.gsub!('〔', '（')
  line.gsub!('〕', '）')
  item, desc = line.split(' : ', 2)
  return nil if desc == ''
  item =~ /^■(.+?)(?: +\{([^{}]+)\})?$/
  word = $1
  pos = $2
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

  {
    word: word,
    descs: [[pos, content]],
  }
end

current_entry = nil
ARGF.each_line do |line|
  entry = parse(line)
  next if entry.nil?
  word = entry[:word]
  pos, content = entry[:descs].first

  if !current_entry
    # replace
    current_entry = {
      word: word,
      contents: [[pos, content]]
    }
  elsif current_entry[:word] == word
    # append
    current_entry[:contents] << [pos, content]
  else
    # output
    print("#{current_entry[:word]}\t")
    lines = []
    current_entry[:contents].each do |pos, content|
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
    current_entry = {
      word: word,
      contents: [[pos, content]]
    }
  end
end
