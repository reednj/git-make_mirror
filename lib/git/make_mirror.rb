require 'trollop'
require "git/make_mirror/version"

module Git
	module MakeMirror
		class App
			
			def main
				opts = Trollop::options do
					version "git-make-mirror #{Git::MakeMirror::VERSION} (c) 2017 @reednj (reednj@gmail.com)"
					banner "Usage: git make-mirror [options] [remote]"
				end

				self.create_repository
			
			end

			def remote
				@remote ||= parse_remote ARGV.last
			end

			def server
				@server ||= SSHCmd.new remote[:host]
			end

			def parse_remote(remote)
				a = remote.split(':')
				{ :host => a.first, :path => a.last }
			end

			def create_repository
				server.exec [
					"mkdir -p #{remote[:path]}",
					"cd #{remote[:path]}",
					'git init',
					'git config receive.denyCurrentBranch ignore'
				]
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
