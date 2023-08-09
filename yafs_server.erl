-module(yafs_server).
-export([start_me_up/3, start/0]).

start() -> 
    yafs:start("./test/"),
    lib_chan:start_server("connection.conf").

start_me_up(MM, _ArgsC, _ArgsS) ->
    loop(MM).

loop(MM) ->
    receive
        {chan, MM, {list_dir, Dir}} ->
            MM ! {send, yafs:ls(Dir)};
        {chan, MM, {get_file, File}} ->
            MM ! {send, yafs:get_file(File)};
        {chan, MM, {make_directory, Dir}} ->
            MM ! {send, yafs:make_directory(Dir)};
        {chan, MM, {put_file, File, Content}} ->
            MM ! {send, yafs:put_file(File, Content)};
        {chan_closed, MM} ->
            true
    end,
    loop(MM).