# File Server written in Erlang

This project was made to learn using Erlang programming language. It use lib_chan library to manage authentication with sockets.

yafs.erl - contains code that manage files & that listen to yafs_server.
yafs_server.erl - contains code that listen to message sent by the client with sockets.
yafs_client.erl - contains functions to do file operations with server.

At the moment, server allows to : 
- list a directory
- download a file
- upload a file
- create a directory
