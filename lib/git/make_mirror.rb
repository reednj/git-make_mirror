require 'trollop'
require "git/make_mirror/version"

module Git
	module MakeMirror
		class App
			
			def main
				opts = Trollop::options do
					version "git-make-mirror #{Git::MakeMirror::VERSION} (c) 2017 @reednj (reednj@gmail.com)"
					banner "Usage: git make-mirror [options] [remote]"
					opt :remote, "create a remote with the given name in the local repository", :type => :string
					opt :local, "configure a local repository to receive pushes", :default => false
					opt :push, "push to the newly created mirror"
				end
				
				Trollop::educate if (remote_url.nil? || remote_url == '') && !opts[:local]

				if opts[:local]
					configure_repository_local
					return
				end
				
				git_remote_name = nil

				puts "creating remote repository"
				self.create_repository

				puts "copying post-receive hook"
				self.copy_hook

				if !opts[:remote].nil?
					git_remote_name = opts[:remote]
					sh "git remote add #{git_remote_name} #{remote_url}"
				end

				if opts[:push]
					sh "git push #{git_remote_name || remote_url} master"
				end
			
			end

			def sh(cmd)
				puts cmd
				system cmd
			end

			def local_hooks_dir
				@hooks_dir ||= File.join(File.dirname(__FILE__), 'hooks')
			end

			def local_hook_file
				@local_hook_file ||= File.join(local_hooks_dir, 'post-receive.rb')
			end

			def remote_url
				(ARGV.last || '').strip
			end

			def remote
				@remote ||= parse_remote(self.remote_url)
			end

			def server
				@server ||= SSHCmd.new remote[:host]
			end

			def parse_remote(remote)
				a = remote.split(':')
				{ :host => a[0], :path => a[1] }
			end

			def create_repository
				server.exec [
					"mkdir -p #{remote[:path]}",
					"cd #{remote[:path]}",
					'git init',
					'git config receive.denyCurrentBranch ignore'
				]
			end

			def configure_repository_local
				hook_file = '.git/hooks/post-receive'
				sh 'git config receive.denyCurrentBranch ignore'
				FileUtils.cp local_hook_file, hook_file
				sh "chmod 775 #{hook_file}"
			end

			def copy_hook
				remote_hook_file = File.join remote[:path], '.git/hooks/post-receive'
				server.scp local_hook_file, remote_hook_file
				server.exec "chmod 775 #{remote_hook_file}"
			end

			def sh(cmd)
				$stderr.puts cmd
				system cmd
			end
		end

	end
end

class SSHCmd
	def initialize(server)
		@server = server
	end

	def exec(cmd)
		cmd = cmd.join ' && ' if cmd.is_a? Array
		`ssh #{@server} '#{cmd}'`
	end

	def scp(from, to)
		`scp #{from} #{@server}:#{to}`
	end
end
