package com.ppca;

public class Test {
	public static void main(String[] args) {
		String test = "alloha/wow/hey";
		String[] group = test.split("/");
		System.out.println(group[1]);
		if(group.length == 2){
			System.out.println("yes");
		}
	}
}
