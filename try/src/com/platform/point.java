package com.platform;

import java.util.ArrayList;
import java.util.List;

public class point {
	int upper;
	int id;
	int rank;
	String name;
	public point(int upper,int id,int rank,String name) {
		this.upper=upper;
		this.id=id;
		this.rank=rank;
		this.name=name;
	}
	public point() {
		
	}
	public void setupper(int upper) {
		this.upper=upper;
	}
	public void setid(int id) {
		this.id=id;
	}
	public void setrank(int rank) {
		this.rank=rank;
	}
	public void setname(String name) {
		this.name=name;
	}
	public int getupper() {
		return this.upper;
	}
	public int getid() {
		return this.id;
	}
	public int getrank() {
		return this.rank;
	}
	public String getname() {
		return this.name;
	}
	public List<point> rebuild(int upper,List<point> list, List<point> sublist,List<point> finallist){
		for(int i=0;i<sublist.size();i++){
			if(sublist.get(i).getupper()==upper){
				finallist.add(sublist.get(i));
				List<point> newlist=new ArrayList<point>();
				for(int k=0;k<list.size();k++){
					if(list.get(k).getupper()==sublist.get(i).getid()){
						newlist.add(list.get(k));
					}
				}
				rebuild(sublist.get(i).getid(),list,newlist,finallist);
			}		
		}	
		return finallist;
	}
}
