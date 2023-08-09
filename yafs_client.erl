-module(yafs_client).
-export([connect/0, ls/1, mkdir/1, get_file/1, download_file/2, upload_file/2]).

connect() ->
    {ok, Pid} = lib_chan:connect("localhost", 1234, yafs, "C3PO", ""),
    register(client_proc, Pid).

ls(Dir) -> 
    lib_chan:rpc(whereis(client_proc), {list_dir, Dir}).

mkdir(Name) ->
    lib_chan:rpc(whereis(client_proc), {make_directory, Name}).

get_file(File) ->
    lib_chan:rpc(whereis(client_proc), {get_file, File}).

download_file(Where, File) ->
    {ok, Content} = get_file(File),
    file:write_file(Where, Content).

upload_file(File, Where) ->
    {ok, Content} = file:read_file(File),
    io:format("~p", [Content]),
    lib_chan:rpc(whereis(client_proc), {put_file, Where, Content}).
