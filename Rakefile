require "rubygems"
require "bundler/setup"
require "shellwords"
require "fileutils"
require "json"
require "hashie"
require "colors"
require "oj"
require "oj/mimic"
require "fileutils"
require "open3"

require_relative 'config/application'

Rails.application.load_tasks

repo = {
      image: "planetgr/arcade-balance",
      dockerfile: "config/dockerfiles/app/Dockerfile"
}

namespace :build do

  #  Executes the command and prints its output to the console.
  #
  def execute_command(cmd)
    puts cmd.hl( :yellow )

    Open3.popen3( cmd ) do |stdin, stdout, stderr, thread|
      stdout.each_line { |line| puts line }
      stderr.each_line { |line| puts line }

      unless thread.value.success?
        puts "Command failed".hl( :red )
        exit 1
      end
    end
  end

  desc "Checks that the working directory is clean"
  task :check do
    puts "Checking working directory state...".hl( :green )
    # unless `git status`.include?("nothing to commit, working directory clean")
    #   puts "Please commit everything first".red
    #   exit 1
    # end
  end

  desc "Builds a specific service as per Rake task arguments"
  task(:build, [:tag]) do |task, args|
    tag = args[:tag]

    unless tag =~ /r\d+\.\d+\.\d+/
      puts "Please supply tag in the format of rX.Y.Z".hl( :red )
      exit 1
    end


    branch, stdout, stderr = Open3.capture3('git symbolic-ref --short -q HEAD')
    hash, stdout, stderr = Open3.capture3('git rev-parse --short HEAD')

    postfix = tag.presence || "v.#{branch.strip.gsub('/', '_')}-#{hash.strip}"
    image_name = repo[ :image ] + ":" + postfix
    puts "Building arcade_balance Docker image as \"#{ image_name }\"".hl( :green )

    execute_command "docker build --build-arg CLONE_BRANCH=#{branch.strip} -f #{ repo[ :dockerfile ] } -t #{ image_name } ."
    # execute_command "docker build -f #{ repo[ :dockerfile ] } -t #{ image_name } ."

    puts "Pushing \"#{ image_name }\" image into registry".hl( :green )
    execute_command "docker push #{ image_name }"

    FileUtils.cd( ".." )
  end

  desc "Builds all services known by the build engine"
  task(:all, {[:tag] => :check}) do |task, args|
    tag = args[:tag]

    Rake::Task["build:build"].invoke(repo, tag)
    Rake::Task["build:build"].reenable
  end

end
