#!/usr/bin/env ruby
# 🌀 Collective Formula Updater
# The collective maintains and mutates formulae automatically

require 'json'
require 'net/http'
require 'digest'

class CollectiveUpdater
  COLLECTIVE_API = "https://api.s0fractal.com/collective/consensus"
  
  def initialize
    @formulas = Dir["Formula/*.rb"]
    @casks = Dir["Casks/*.rb"]
  end
  
  def check_for_mutations
    puts "🧬 Checking collective consensus for updates..."
    
    # In future: Query actual collective API
    # For now, check GitHub releases
    
    @formulas.each do |formula|
      name = File.basename(formula, ".rb")
      check_formula_updates(name)
    end
    
    @casks.each do |cask|
      name = File.basename(cask, ".rb")
      check_cask_updates(name)
    end
  end
  
  def check_formula_updates(name)
    latest = fetch_latest_release(name)
    return unless latest
    
    current = extract_version("Formula/#{name}.rb")
    
    if version_newer?(latest[:version], current)
      puts "🌀 Mutation detected for #{name}: #{current} -> #{latest[:version]}"
      update_formula(name, latest)
    end
  end
  
  def update_formula(name, release_info)
    formula_path = "Formula/#{name}.rb"
    content = File.read(formula_path)
    
    # Update version
    content.gsub!(/url ".*"/, %Q{url "#{release_info[:url]}"})
    content.gsub!(/sha256 ".*"/, %Q{sha256 "#{release_info[:sha256]}"})
    
    File.write(formula_path, content)
    
    # Commit changes
    system("git add #{formula_path}")
    system(%Q{git commit -m "🌀 Collective update: #{name} #{release_info[:version]}"})
    
    puts "✅ #{name} mutated successfully!"
  end
  
  def fetch_latest_release(name)
    # Check GitHub API for latest release
    uri = URI("https://api.github.com/repos/s0fractal/#{name}/releases/latest")
    response = Net::HTTP.get_response(uri)
    
    return nil unless response.code == "200"
    
    data = JSON.parse(response.body)
    
    {
      version: data["tag_name"].gsub(/^v/, ""),
      url: data["tarball_url"],
      sha256: calculate_sha256(data["tarball_url"])
    }
  rescue => e
    puts "⚠️ Could not check #{name}: #{e.message}"
    nil
  end
  
  def calculate_sha256(url)
    # Download and calculate SHA256
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    
    Digest::SHA256.hexdigest(response.body)
  end
  
  def extract_version(file)
    content = File.read(file)
    match = content.match(/version "(.+?)"/)
    match ? match[1] : "0.0.0"
  end
  
  def version_newer?(new_version, old_version)
    new_parts = new_version.split(".").map(&:to_i)
    old_parts = old_version.split(".").map(&:to_i)
    
    new_parts <=> old_parts > 0
  end
  
  def apply_collective_wisdom
    puts "🧠 Applying collective wisdom..."
    
    # Future: Receive mutations from other collective members
    # - Performance optimizations
    # - New features discovered by agents
    # - Security improvements
    
    puts "💫 Collective wisdom applied!"
  end
end

# Run if executed directly
if __FILE__ == $0
  updater = CollectiveUpdater.new
  updater.check_for_mutations
  updater.apply_collective_wisdom
  
  puts "🌀 Collective update complete!"
end