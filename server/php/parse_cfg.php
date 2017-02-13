<?php
	/**
	 * @author hbc 670762953@qq.com
	 * @time(2016/3/11)
	 * @doc配置解析
	 *
	 */
	error_reporting(E_ALL & ~E_NOTICE);
	header("Content-type: text/html; charset=utf-8");	
	define('ID', 	"id");			//服务端宏输出文件的value 字段
	define('MACRO', "macro");		//服务端宏输出文件的key 字段
	define('CFG_DIR', "../cfg");
	define('INCLUDE_DIR', "../include");
	define('cfg_hrl', "cfg_hrl.hrl");


	$cfgFile  = $argv[1]; //eg：cfg_buff
	$erlFile  = $argv[2]; //eg: cfg.erl
	$xlsxFile = $argv[3];//eg: cfg.xlsx
	$macroTag = $argv[4];
	create_dir();
	$parseData = parse_data($cfgFile, $erlFile, $xlsxFile, "server");
	$parseData != false && output_file($cfgFile, $parseData);
	!empty($macroTag) && generate_macro($cfgFile, $xlsxFile); 

	/**
	 * 构造项目需要的目录
	 * @return [type] [description]
	 */
	function create_dir(){
		!is_dir(CFG_DIR) ? mkdir(CFG_DIR, 0777, true) : null;
	}
	/**
	 * 解析相应的配置到客服端/服务端
	 * @param  [type] $cfgFile  [配置文件名(不包括后缀)]
	 * @param  [type] $erlFile  [配置生成的erl文件名]
	 * @param  [type] $xlsxFile [配置文件名]
	 * @param  string $tag      [标记客户端(client)/服务端(server)]
	 * @return [type]           [description]
	 */
	function parse_data($cfgFile, $erlFile, $xlsxFile, $tag = "server"){
		$iex_content_arrays = explode("\n", mb_convert_encoding(file_get_contents("{$xlsxFile}"), "utf-8", "gbk"));
		$colNameArr = explode("\t", $iex_content_arrays[1]);
		$colNeedArr 		= explode("\t", $iex_content_arrays[ $tag=="server"? 3 : 2 ]);
		if(!in_array(1, $colNeedArr)) return false;
		$tag == "server" ? output_fix($cfgFile, $colNeedArr, $colNameArr) : "";
		$iex_data_arrays 	= array();
		for($i = 4; $i < count($iex_content_arrays) - 1; $i++){
			$line_arrays = explode("\t", $iex_content_arrays[$i]);
			$line = array();
			for($j = 0; $j < count($line_arrays); $j++){
				if($colNeedArr[$j] == 0) continue;
				$val = array(trim($colNameArr[$j]) => trim($line_arrays[$j]));
				$line = array_merge($line, $val);		
			}
			$iex_data_arrays[] = $line;
		}
		return $iex_data_arrays;
	}

	/**
	 * 输出文件到形成配置
	 * @param  [type] $cfgFile [description]
	 * @param  [type] $data    [description]
	 * @return [type]          [description]
	 */
	function output_file($cfgFile, $data){
		$outputString = "";
		foreach ($data as $line) {
			$id = array_shift($line);
			$outputData = "get({$id}) -> #{$cfgFile}{";			
			foreach ($line as $key => $value) {
				$value = trim($value, '"');
				if (preg_match("/[\x80-\xff]/", $value)) {
						$value = "\"$value\"";
					}				
				$outputData .= "{$key} = {$value}, ";
			}
			$outputData = rtrim($outputData, ", ")."};\n";
			$outputString .= $outputData;
		}
		$outputString .= "get(_) -> undefined.";
		$fix = "-module({$cfgFile}).\n-include(\"cfg_hrl.hrl\").\n\n-export([get/1]).\n\n";
		file_put_contents(CFG_DIR."/{$cfgFile}.erl", $fix.$outputString);
	}

	/**
	 * 服务端输出到hrl文件形成record
	 * @param  [type] $cfgFile    [description]
	 * @param  [type] $colNeedArr [配置表中服务端的需求字段]
	 * @param  [type] $data       [配置表的字段数组]
	 * @return [type]             [ignore]
	 */
	function output_fix($cfgFile, $colNeedArr, $data){
		$record = "-record($cfgFile, {";
		for ($i=0; $i < count($data); $i++) { 
			if($colNeedArr[$i] == 0) continue;
			$record .= trim($data[$i]).", ";
		}
		$record = rtrim($record, ", ")."}).\n";
		$content = file_get_contents(INCLUDE_DIR."/cfg_hrl.hrl");
		$newContent = trim(preg_replace("/-record\(".$cfgFile.",.*}\)./", "", $content));
		file_put_contents(INCLUDE_DIR."/".cfg_hrl, $newContent."\n".$record);
	}

	/**
	 * 生成相应的宏定义文件,会根据配置表的macro 和id 字段生成对应的宏文件,放在include目录下
	 * @param  [type] $cfgFile  [description]
	 * @param  [type] $xlsxFile [description]
	 * @return [type]           [description]
	 */
	function generate_macro($cfgFile, $xlsxFile){
		$iex_content_arrays = explode("\n", mb_convert_encoding(file_get_contents("{$xlsxFile}"), "utf-8", "gbk"));
		$colNameArr = explode("\t", $iex_content_arrays[1]);
		$iex_data_arrays 	= array();
		$content = "";
		for($i = 4; $i < count($iex_content_arrays) - 1; $i++){
			$line_arrays = explode("\t", $iex_content_arrays[$i]);
			$id = array_search(ID, $colNameArr);
			$macro = array_search(MACRO, $colNameArr);
			$val = "-define(".$line_arrays[$macro].", $line_arrays[$id]).\n";
			$content .= $val;
		}
		file_put_contents(INCLUDE_DIR."/{$cfgFile}.hrl", $content);
	}