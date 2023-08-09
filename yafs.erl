-module(yafs).
-export([start/1, ls/1, get_file/1, make_directory/1]).

start(Root) -> register(yafs, spawn(fun() -> loop(Root) end)).

loop(Root) ->
    receive
        {Client, {list_dir, Dir}} ->
            Full = filename:join(Root, Dir),
            Client ! {self(), file:list_dir(Full)};
        {Client, {get_file, File}} ->
            Full = filename:join(Root, File),
            Client ! {self(), file:read_file(Full)};
        {Client, {make_directory, Dir}} ->
            Full = filename:join(Root, Dir),
            Client ! {self(), file:make_dir(Full)}
    end,
    loop(Root).

ls(Dir) ->
    yafs ! {self(), {list_dir, Dir}},
    FileServer = whereis(yafs),
    receive
        {FileServer, Message} -> Message
    end.

get_file(File) ->
    yafs ! {self(), {get_file, File}},
    FileServer = whereis(yafs),
    receive
        {FileServer, Message} -> Message
    end.

make_directory(Dir) ->
    yafs ! {self(), {make_directory, Dir}},
    FileServer = whereis(yafs),
    receive
        {FileServer, Message} -> Message
    end.