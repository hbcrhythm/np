<?php
	/**
	 * @author hbc 670762953@qq.com
	 * @time(2016/3/25)
	 * @doc 协议解析
	 * 	    lib_文件和ph_文件的生成
	 * @end
	 */
	error_reporting(E_ALL & ~E_NOTICE);
	header("Content-type: text/html; charset=utf-8");	
	define('LIB_TYPE', "lib_type");
	define('PH_TYPE', "ph_type");
	define('SRC_DIR', "../src/");

	$protoFile 		= $argv[1];
	$parseFile 		= "../src/parse.erl";
	$unparseFile 	= "../src/unparse.erl";

	switch ($protoFile) {
		case 'undefined':
			$parseName 			= basename($parseFile, ".erl");
			$unparseName		= basename($unparseFile, ".erl");
			$parseString 		= undefined($parseName);
			$unparseString 		= undefined($unparseName);
			$parsePattern    	= '/'."[\s]*?".$parseName."\([\s]*?_[\s]*?\)[\s]*?->[\s]*undefined[\s]*?\.".'/';
			$unparsePattern 	= '/'."[\s]*?".$unparseName."\([.\s]*?_[,_.\s]*?\)[\s]*?->[\s]*undefined[\s]*?\.".'/';
			$newParseString 	= del_replace($parsePattern, $parseString, file_get_contents($parseFile));
			$newUnParseString 	= del_replace($unparsePattern, $unparseString, file_get_contents($unparseFile));
			file_put_contents($parseFile, $newParseString);
			file_put_contents($unparseFile, $newUnParseString);
			break;
		default:
			list($parse, $unparse) = parse($protoFile, file_get_contents("../../proto/".$protoFile. ".proto"), $phFile, $libFile);
			$pattern 			   = '/%%'."[.\s]*?start ".$protoFile."[.\s\S]*%%[.\s]*?end ".$protoFile."[^%]*".'/i';
			$newParseFile 		   = replace($pattern, $parse, file_get_contents($parseFile));
			$newUnParseFile 	   = replace($pattern, $unparse, file_get_contents($unparseFile));
			file_put_contents($parseFile, $newParseFile);
			file_put_contents($unparseFile, $newUnParseFile);
			break;
	}

	/**
	 * 解析协议生成相应的协议号
	 * @param  [type] $protoFile [协议文件]
	 * @return [type]            [description]
	 */
	function parse($protoFile, $content, $phFile, $libFile){
		$filename = basename($protoFile);
		$parsePattern = '/\/\/'."[.\s]*?pt_no[.\s]*:[.\s]*(\d+).*\n?[.\s]*?message[.\s]*?([return_|request_]\w+)[.\s]*{[.\s]*\n?" .'/i';
		$unparsePattern = '/\/\/'."[.\s]*?pt_no[.\s]*:[.\s]*(\d+).*\n?[.\s]*?message[.\s^\w]*?(\w+?_\w+)[.\s]*{[.\s]*\n?" .'/i';
		// $unparsePattern2 = '/\/\/'."[.\s]*?pt_no[.\s]*:[.\s]*(\d+).*\n?[.\s]*?message[.\s]*?(return_\w+)[.\s]*{[.\s]*\n?" .'/i';
		
		preg_match_all($parsePattern, $content, $parseOut);
		preg_match_all($unparsePattern, $content, $unparseOut);
		// preg_match_all($unparsePattern2, $content, $unparseOut2);

		$parseString .= "%%start {$filename}\n";
		$unparseString .= "%%start {$filename}\n";
		for ($i=0; $i < count($parseOut[1]); $i++) {
			$parseString .= "parse({$parseOut[2][$i]}) -> [{module_pb, {$filename}_pb}, {module_logic, ph_${filename}}, {pt_no, {$parseOut[1][$i]}}];\n";
        }
        for ($i=0; $i < count($unparseOut[1]); $i++){
            $tag = strstr($unparseOut[2][$i], "request")? "server":"client";
            $unparseString .= "unparse({$tag}, {$unparseOut[1][$i]}) -> [{module_pb, {$filename}_pb}, {module_logic, ph_${filename}}, {function, decode_{$unparseOut[2][$i]}}];\n";
            $phFileContent .= "handle(#{$unparseOut[2][$i]}{}, State) ->\n\t{ignore, State};\n\n";
        }
        // for ($i=0; $i < count($unparseOut2[1]); $i++) { 
        //     $unparseString .= "unparse(client, {$unparseOut2[1][$i]}) -> [{module_pb, {$filename}_pb}, {module_logic, ph_${filename}}, {function, decode_{$unparseOut2[2][$i]}}];\n"; 
        // }
		$parseString .= "%%end {$filename}\n";
		$unparseString .= "%%end {$filename}\n";
		create_file(LIB_TYPE, $protoFile);
		create_file(PH_TYPE, $protoFile, $phFileContent);
		return array($parseString, $unparseString);
	}

	function create_file($type, $protoFile, $Content = ""){
		$phFile 	= SRC_DIR."ph_".$protoFile.".erl";
		$libFile 	= SRC_DIR."lib_".$protoFile.".erl";
		if($type == PH_TYPE && !file_exists($phFile)){
			$fileContent = "-module(ph_{$protoFile}).\n-author('').\n%% @doc 这里填写您的模块描述\n%% @end\n-include(\"{$protoFile}_pb.hrl\").\n\n-export([handle/2]).\n\n\n";
			$fileContent .= $Content;
			$fileContent .= "handle(_, State) ->\n\t{ignore, State}.\n";
			file_put_contents($phFile, $fileContent);
			return true;
		}
		if($type == LIB_TYPE && !file_exists($libFile)){
			$fileContent = "-module(lib_{$protoFile}).\n-author('').\n%% @doc 这里填写您的模块描述\n%% @end\n-include(\"{$protoFile}_pb.hrl\").\n\n-export([]).\n";
			file_put_contents($libFile, $fileContent);
			return true;
		}
		return false;
	}

	/**
	 * 替换字符串,将原先的当前protofile协议文件的erl内容替换为新的erl内容
	 * @param  [type] $protoFile  [协议文件]
	 * @param  [type] $newContent [新内容]
	 * @param  [type] $content    [内容]
	 * @return [type]             [description]
	 */
	function replace($pattern, $newContent, $content){
		if(preg_match($pattern, $content)){
			return preg_replace($pattern, $newContent, $content);
		}
		return $content.$newContent;
	}

	function del_replace($pattern, $newContent, $content){
		if(preg_match($pattern, $content)){
			$content = preg_replace($pattern, "", $content);
		}
		return $content.$newContent;
	}

    /**
     * 返回对应的undefined内容
     * @param  [type] $string [description]
     * @return [type]         [description]
     */
	function undefined($string){
		if($string == "unparse") return $string."(_, _) -> undefined.\n";
		return $string."(_) -> undefined.\n";
	}
?>
