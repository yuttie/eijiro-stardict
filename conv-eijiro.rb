#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler/setup'

current = nil
File.open('EIJIRO/EIJI-1441.TXT', 'r:CP932:UTF-8') do |file|
  file.each_line do |line|
    line.chomp!
    item, desc = line.split(' : ', 2)
    _, entry, _, pos = /^■(.+?)( +\{([^{}]+)\})?$/.match(item).to_a
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
      content << "<span size=\"small\">・#{ex}</span>"
      content << "<span size=\"small\">#{ex_note}" if ex_note
    end

    if !current
      # replace
      current = {}
      current[:entry] = entry
      current[:contents] = []
      current[:contents] << [pos, content]
    elsif current[:entry] == entry
      # append
      current[:contents] << [pos, content]
    else
      # output
      print("#{current[:entry]}\t")
      lines = []
      current[:contents].each do |pos, content| 
        lines << "<b>〔#{pos}〕</b>" if pos
        content.each do |c| 
          lines << "    #{c}"
        end
      end
      puts(lines.join('\n'))
      # replace
      current = {}
      current[:entry] = entry
      current[:contents] = []
      current[:contents] << [pos, content]
    end
  end
end
