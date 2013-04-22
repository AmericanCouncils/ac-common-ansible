# Ansible #

This repo contains ansible configuration used available to all projects.  It does not contain any information related to specific projects.

To use ansible for managing and deploying any particular project, you should create a `{project_name}-ansible` repository.  In that repository you
should add this as a submodule in the `common/` directory.

## Adding new technologies ##

If using a new tech that isn't project-specific, you should add common ansible config for it here.  That's a two part job:

1. Include a playbook to install and configure the necessary software
2. Add a supervisord config file for managing any processes that should be run, instead of relying on whatever the defaults are

Look at config for `haproxy` or `nginx` to get an idea of how to do this.

> Note: When you configure the process for whichever technology to run under supervisord, you must configure it to run in the foreground.  There's no standard way to do this, every program is different.
