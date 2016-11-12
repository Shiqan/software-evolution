@contributor{Ferron Saan - 10386831}

module \loc

import IO;
import String;
import util::FileSystem;
import List;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import common;


public void init() {
	int lines = getLoc(file);
}
	
/**
 * Get the LOC of a file.
 */
public int getLocFile(loc location) {
	list[str] lines = getLines(location);
	int n = size(lines);
	debugger("Number of lines in <location>");
	debugger(n);
	return n;
}

/**
 * Get the average LOC of a file.
 */
public int getAvgLocFile(loc location) {
    list[int] result = [];
    
    for(f <- getFiles(location)) {
    	result = size(getLines(f)) + result;
    }
    
    int n = sum(result) / size(result);
	
	debugger("Avg number of lines per file:");
	debugger(n);
	return n;
}

/**
 * Get the average LOC of a method.
 */
public int getAvgLocMethod(model) {
    list[int] result = [];
    
    for(method <- methods(model)) {
    	result = size(getLines(method)) + result;
    }
    
    int n = sum(result) / size(result);
	
	debugger("Avg number of lines in method:");
	debugger(n);
	return n;
}

/**
 * Get the average LOC of a class.
 */
public int getAvgLocClass(model) {
    list[int] result = [];
    
    for(c <- classes(model)) {
    	result = size(getLines(c)) + result;
    }
    
    int n = sum(result) / size(result);
	
	debugger("Avg number of lines in class:");
	debugger(n);
	return n;
}