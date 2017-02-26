np
=======
Game server for erlang

1、字节流说明
-----
	1> 如果协议中使用了字节流字段的话,那么前端传过来的数据会被解析为二进制,但如果我这个字节流字段在服务端用的话是当做整形来用的话,那么收到数据的时候就要进行相应的流转换,因为我们record的字段类型和数据库的字段类型保持一致。
	2> 如果你在db中fetch数据,并使用了as_record, 转换后的record的数据格式是和数据库保持一致的,所以如果你要将这个数据发送给前端并且record里面包含了字节流字段的话,你也要进行相应的转换。

2、关于as_record说明
-----
	1> #as_record 里面的name 是你要转成的record name, list 是你要转换成的record 的fields 列表, 并且你的查询语句所查询的字段的字段名和需要转换成的record的name 要保持一致,不一致的字段将导致转换失败,undefined.


3、关于"ph_" module和 "lib_" module
-----
	1> 这两个逻辑模块(不包括test目录下的) 是根据"module".proto自动生成的,并且只会生成一次。
	2> 如果你修改了"module".proto  ph模块和lib模块的内容并不会改变,因为这两个模块只有文件不存在的时候生成一次,之后框架不会自动的对这两个模块进行操作,如果你删除了某个模块。

4、关于parse.erl 和 unparse.erl
-----
	1> parse包括项目里所有的 proto_name-> pt_no的映射
	2> unparse 包括了项目所有的pt_no -> proto_name 的映射,并且unparse分两个部分(server, PtNo)，一个部分是服务端解析协议部分(client, PtNo), 一个部分是客户端解析协议部分。
	3> 这两个文件的内容会根据../proto 里面的内容的模块内容的改变而改变,改变是覆盖形式的,既覆盖旧的对应模块的数据。
	4> parse.erl 和unparse.erl 两个文件和文件的前缀内容是项目编译的时候生成的, 如果你删除了文件的前缀内容,并没有删除文件,那这样是会报错的,你必须连文件也一起删掉,下一次编译才会重新生成。
	5> 你也可以删除proto文件夹下面的bak文件，这样文件的“协议”内容会重新刷新一次(不包括前缀内容和文件).

5、关联demo
-----
	1> h5 game client https://github.com/hbcrhythm/EgretGameEngine (持续更新中...)
	2> web     server https://github.com/hbcrhythm/Vue-cnodejs (架构已搭建完成) 

联系我们
=======
	1>  email: labihbc@gmail.com 
	2>  qq 	 : 670762853