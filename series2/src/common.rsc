@contributor{Ferron Saan - 10386831}

module common

import IO;
import String;
import List;
import util::FileSystem;

public loc testproject = |project://testproject/src|;
public loc project = |project://smallsql/src|;
public loc project2 = |project://hsqldb-2.3.1/hsqldb/src|;

private bool debug = true;
public void debugger(value s) {
  if (debug) println(s);
}

@doc{Extract the file of a method location}
public str extractFile(loc method) {
	return substring(method.path, 0, findLast(method.path, "/"));	
}

@doc{Get all files of a project}
public list[loc] getFiles(loc location, str ext="java") {
	debugger("Getting all files of <location> with extension <ext>");
	
	// Only java files and not the test files
	list[loc] result = [f | /file(f) <- crawl(location), f.extension == ext,  /junit/ !:= f.path, /test/ !:= f.path];

	//debugger(size(result));	
	return result;
}

@doc{Returns string with all whitespaces removed}
public str strip(str s) {
	list[str] toStrip = [" ", "\t"];
  
	for (rm <- toStrip) {
		s = replaceAll(s, rm, "");
	}
	
	return s;
} 

public list[str] getLines(loc location) {
	return readFileLines(location);
}

@doc{Get all the code lines of a file}
public list[tuple[int linenumber, str line]] filterLines(list[str] allLines) {
	

	list[tuple[int linenumber, str line]] result = [];
	bool comment = false;

	int linecounter = 1;
	for(s <- allLines) {    	
    	// Remove leading and trailing spaces
    	s = trim(s);
    	
    	// Skip multi line comments
    	if (comment) {
    		if (/.*\*\/$/ := s) {
    			//debugger("Multi line COMMENTS" + s);
    			comment = false;
    		}
    		continue;
    	} else {
    		if (/^\/\*.*/ := s) {
    			//debugger("Multiline COMMENTS" + s);
    			comment = true;
    			continue;
    		}
    	}
    	
    	// Skip single line comments
    	if (/^\/\// := s) {
    		//debugger("Single COMMENTS" + s); 
    		continue;
    	}
	
	    // Skip lines with only brackets
	   	if (/\{|\}/ := s && size(s) == 1) continue;
	   	
	   	// Remove all whitespaces from string
	   	//s = strip(s);
	   
	   // Skip empty lines
	    if (!isEmpty(s)) {
	      result += <linecounter, s>;
	    }
	    
	    linecounter += 1;
  	}
  	
	//debugger("Lines in file <location>");
	//debugger(result);
	
	return result;
}

@doc{Get the total LOC of a project}
public int getLocProject(loc location) {
	list[int] result = [];
    
    for(f <- getFiles(location)) {
    	result += size(getLines(f));
    }
    
    int n = sum(result);
	debugger("Total number of lines of project <location>: <n>");
	return n;
}

