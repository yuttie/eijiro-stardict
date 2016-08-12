#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

ARGF.set_encoding('CP932:UTF-8')

def parse_entry(line)
  line.chomp!
  line.gsub!('\\', '¥')
  line.gsub!('<', '&lt;')
  line.gsub!('>', '&gt;')
  line.gsub!('〔', '（')
  line.gsub!('〕', '）')
  line.gsub!(/｛.+?｝/, '')
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


def print_entry(entry)
    print("#{entry[:word]}\t")
    entry[:descs].each do |pos, content|
      if pos
        print("<span weight=\"bold\">〔#{pos}〕</span>#{content[0]}\\n") if pos
        content[1..-1].each do |c|
          print("\t#{c}\\n")
        end
      else
        content.each do |c|
          print("#{c}\\n")
        end
      end
    end
    print("\n")
end


current_entry = nil
ARGF.each_line do |line|
  entry = parse_entry(line)
  next if entry.nil?
  word = entry[:word]
  pos, content = entry[:descs].first

  if !current_entry
    # replace
    current_entry = entry
  elsif current_entry[:word] == word
    # append
    current_entry[:descs] << [pos, content]
  else
    # output
    print_entry(current_entry)
    # replace
    current_entry = entry
  end
end
