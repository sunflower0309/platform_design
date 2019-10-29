package com.baidu;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;
public class sub_info{
	private String sub_id;
	private String sub_score;
	public String get_id() {
		return this.sub_id;
	}
	public String get_score() {
		return this.sub_score;
	}
	public void set_id(String id) {
		this.sub_id=id;
	}
	public void set_score(String score) {
		this.sub_score=score;
	}
}