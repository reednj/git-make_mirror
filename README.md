# git make-mirror

git-make_mirror is a utility for easily creating *non-bare* pushable remotes. This is very useful for creating deployment endpoints.

## Installation

    gem install git-make_mirror

## Usage

    git make-mirror [options] <remote_name>

For example the following will create a empty repository on the host given, and set the options so that it can be pushed to, even though it is not bare. A post-receive hook will reset the working directory to HEAD after every push.

    git make-mirror reednj@twtxt.xyz:code/hello.git

When running the command from a git repository, the `-p` option will immediately push the current repository to the remote.

    # will immediately push the current repo into hello.git
    git make-mirror -p reednj@twtxt.xyz:code/hello.git

The `-r` option will add the remote to the current repository with the provided name.

    # after running the repository will have the new remote 'prod'
    git make-mirror -r prod reednj@twtxt.xyz:code/hello.git

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

