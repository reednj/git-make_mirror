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

				puts "Hello, world"
			end
		end
	end
end
