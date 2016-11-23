@contributor{Ferron Saan - 10386831}

module scores

import IO;
import String;
import List;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import common;
import cc;
import \loc;
import duplicate;
import testcoverage;
import export;

@doc{Determine the risk of duplication of a project}
public str riskDuplication(loc location) {
	debugger("\n=== DUPLICATION ===\n");

	map[list[str], list[loc]] result = findDuplicateCode(location);
	export_duplication(result);

	num dup = sum([size(result[l]) | l <- result]) - size([l | l <- result]);
	total_loc = getLocProject(location);
 	
 	// Lineblocks of 6.
 	int d = percent(dup*6, total_loc);
 	debugger("Percentage of duplicate lines: <d>%");
/*  
++ 0-3%
+ 3-5%
o 5-10%
- 10-20%
-- 20-100%
*/
	if (d < 3) {
		return "++";
  	} else if (d < 5) {
    	return "+";
 	} else if (d < 10) {
    	return "0";
  	} else if (d < 20) {
    	return "-";
  	} else {
    	return "--";
  	}
}

@doc{Determine the risk of test coverage of a project}
public str riskCoverage(loc location) {
	debugger("\n=== TEST COVERAGE ===\n");

	int d = getTestCoverage(location);
/*  
++ 95-100%
+ 80-95%
o 60-80%
- 20-60%
-- 0-20%
*/
	if (d < 20) {
		return "--";
  	} else if (d < 60) {
    	return "-";
 	} else if (d < 80) {
    	return "0";
  	} else if (d < 95) {
    	return "+";
  	} else {
    	return "++";
  	}
}

@doc{Determine the risk volume of a project}
public str riskLOC(loc location) {
	debugger("\n=== LINES OF CODE ===\n");

	int total_loc = getLocProject(location);

	num kloc = total_loc / 1000;
/*  
++ 0-66
+ 66-246
o 246-665 
- 655-1,310
-- > 1,310
*/

	if (kloc < 66) {
		return "++";
  	} else if (kloc < 246) {
    	return "+";
 	} else if (kloc < 665) {
    	return "0";
  	} else if (kloc < 1310) {
    	return "-";
  	} else {
    	return "--";
  	}
}

@doc{Determine the risk of unit size of a project}
public str riskUnitSize(loc location) {
	debugger("\n=== UNIT SIZE ===\n");

	model = createM3FromEclipseProject(location);

	map[str, list[loc]] values = (
		"without": [],
		"moderate": [],
		"high": [],
		"veryhigh": []);
   	
   	
   	for(method <- methods(model)) {
    	r = size(getLines(method));
    	if (r <= 10) {
	    	values["without"] += [method];
	    } else if (r  <= 20) {
	      	values["moderate"] += [method];
	    } else if (r  <= 50) {
	      	values["high"] += [method];
	    } else {
	      	values["veryhigh"] += [method];
    	}
    }
       
    debugger([[x, size(values[x])] | x <- values]);
    debugger("These methods have a very high risk: <values["veryhigh"]>");
    export_unitsize(values);
    
    int total_loc = getLocProject(location);
    
	int moderate_loc = sum([getLocFile(x) | x <- values["moderate"]]);
	int m1 = percent(moderate_loc,total_loc);
	
	int high_loc = sum([getLocFile(x) | x <- values["high"]]);
	int m2 = percent(high_loc,total_loc);
	
	int vhigh_loc = sum([getLocFile(x) | x <- values["veryhigh"]]);
	int m4 = percent(vhigh_loc,total_loc);
	/*
	++	25% 0% 0%
	+ 30% 5% 0%
	o 40% 10% 0%
	- 50% 15% 5%
	*/
	if (m1 <= 25 && m2 == 0 && m4 == 0) {
		return "++";
	} else if (m1 <= 30 && m2 <= 5 && m4 == 0) {
		return "+";
	} else if (m1 <= 40 && m2 <= 10 && m4 == 0) {
		return "0";
	} else if (m1 <= 50 && m2 <= 15 && m4 <= 5) {
		return "-";
	} else {
		return "--";
	}
}

@doc{Determine the risk of complexity of a project}
public str riskCC(loc location) {
	debugger("\n=== COMPLEXITY ===\n");

	map[str, list[loc]] values = (
		"without": [],
		"moderate": [],
		"high": [],
		"veryhigh": []);
   	
   	
   	for (f <- getFiles(location)) {
   		lrel[int cc, loc method] result = getCC(f);
   		   		
   		for (r <- result) {
   			if (r[0] <= 10) {
		    	values["without"] += [r[1]];
		    } else if (r[0]  <= 20) {
		      	values["moderate"] += [r[1]];
		    } else if (r[0]  <= 50) {
		      	values["high"] += [r[1]];
		    } else {
		      	values["veryhigh"] += [r[1]];
	    	}
   		}  		
   	}
   		  
    debugger([[x, size(values[x])] | x <- values]);
    debugger("These methods have a very high risk: <values["veryhigh"]>");
    export_cc(values);
    
    int total_loc = getLocProject(project);
    
	int moderate_loc = sum([getLocFile(x) | x <- values["moderate"]]);
	int m1 = percent(moderate_loc,total_loc);
	
	int high_loc = sum([getLocFile(x) | x <- values["high"]]);
	int m2 = percent(high_loc,total_loc);
	
	int vhigh_loc = sum([getLocFile(x) | x <- values["veryhigh"]]);
	int m4 = percent(vhigh_loc,total_loc);
	/*
	++	25% 0% 0%
	+ 30% 5% 0%
	o 40% 10% 0%
	- 50% 15% 5%
	*/
	if (m1 <= 25 && m2 == 0 && m4 == 0) {
		return "++";
	} else if (m1 <= 30 && m2 <= 5 && m4 == 0) {
		return "+";
	} else if (m1 <= 40 && m2 <= 10 && m4 == 0) {
		return "0";
	} else if (m1 <= 50 && m2 <= 15 && m4 <= 5) {
		return "-";
	} else {
		return "--";
	}
}
