# Symlink Deployer plugin #

This resource plugin can be used for symlinking PHP content to a webserver document root.

# Overview #

The Symlink Deployer plugin is a Deployit plugin that supports the deployment of staged content (i.e. PHP scripts) to a target directory, by use of modifying symlinkinks. For instance, this process provides a faster and more reliable manner to load new content to an http server content root. 

This process is typically used when deploying PHP content to a webserver without disrupting / invalidating content on the webserver, as:
- first you make sure all content / scripts are available on the target machine.
- the process of symlinking is very fast. Much faster than the process of copying content.

# Requirements #

* **Deployit requirements**
	* **Deployit**: version 3.7 and up.

# Installation #

Place the plugin JAR file into your `SERVER_HOME/plugins` directory and restart.
Note: this plugin only works on systems supporting shell scripts (MS system is not supported).

# Usage

The plugin depends on four variables:
`Symlinked Document Root`, this value should be equal the the value of the document root directory of the webserver you are about to deploy content to.
`Next Content Location`, the directory where the new content you are about to deploy, the staged content, can be found.
`Previous Content Location`, the directory to which content that is about to be replaced should be copied to for (later) rollback purposes.
`Actual Content Location`, the directory where -current- content can be found, being the content that is currently being served by the webserver.

Make sure the content you are about to deploy is available in the `Next Content Location`-directory (for instance by using the File plugin). 

When running the Symlink deployer, the following process will run:
1. `Symlinked Document Root` is symlinked to `Next Content Location`.
2. `Previous Content Location` directory is emptied.
3. `Actual Content Location` content is moved to `Previous Content Location`.
4. `Next Content Location` content is copied to `Actual Content Location`.
5. `Symlinked Document Root` is symlinked to `Actual Content Location`.
6. (optional) a caching server is cached by sending an HTTP BAN to a specified url

When running the Symlink deployer in rollback mode, the following process will run:
1. `Symlinked Document Root` is symlinked to `Previous Content Location`.
2. `Next Content Location` directory is emptied.
3. `Actual Content Location` content is moved back to `Next Content Location`.
4. `Previous Content Location` content is copied to `Actual Content Location`.
5. `Symlinked Document Root` is symlinked to `Actual Content Location`.
6. `Previous Content Location` content is removed (as a rollback can only be perfomed 1 time).
7. (optional) a caching server is cached by sending an HTTP BAN to a specified url


Flushing options
It is often the case that when new PHP content is deployed, a caching server is to be flushed as well.
Varnish offers the option to flush the cache by performing an HTTP BAN.
Optionally provide a BAN statement in the Varnish Options tab in case you would like to flush the cache after a symlink deploy.


# Configuration #

See the Usage section. Make sure the deployit user is allowed to perform symlink operations on the targetsystem.
In case you are symlinking to a webserver, make sure that the value for `Symlinked Document Root` equals the Document Root of the webserver.
No physical content should be present in the document root of the webserver anymore. Physical content should be located in `Actual Content Location`.

In default state, the document root should be configured to be a symlink to `Actual Content Location`.
Make sure the directories for Next Content Location, Previous Content Location, Actual Content Location and Symlinked Document Root are already available on target system with proper permissions. (puppetize!)
When specifying directories: omit the final slash '/'.
