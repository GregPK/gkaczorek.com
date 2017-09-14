#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'

file = ARGV[0]

puts "Publishing #{file}"

draft_dir = '_drafts/'
draft_path = draft_dir+file
front_matter = YAML.load(File.read(draft_path))

date = front_matter.fetch('date') { fail "Date must be specified in front matter" }
date_str = Date.parse(date).to_s

dest_file = date_str + '-' + file
dest_path = '_posts/' + dest_file

FileUtils.mv(draft_path, dest_path)
puts "File published to #{dest_path}"
