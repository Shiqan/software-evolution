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


public void riskDuplication() {

	d = findDuplicateCode(project);
/*  
++ 0-3%
+ 3-5%
o 5-10%
- 10-20%
-- 20-100%
*/
	if (d < 3) {
		debugger("++");
  	} else if (d < 5) {
    	debugger("+");
 	} else if (d < 10) {
    	debugger("0");
  	} else if (d < 20) {
    	debugger("-");
  	} else {
    	debugger("--");
  	}
}

public void riskLOC() {

	total_loc = getLocProject(project);

	num kloc = total_loc / 1000;
/*  
++ 0-66
+ 66-246
o 246-665 
- 655-1,310
-- > 1,310
*/

	if (kloc < 66) {
		debugger("++");
  	} else if (kloc < 246) {
    	debugger("+");
 	} else if (kloc < 665) {
    	debugger("0");
  	} else if (kloc < 1310) {
    	debugger("-");
  	} else {
    	debugger("--");
  	}
}

public void riskUnitSize() {

	model = createM3FromEclipseProject(project);

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
    
    total_loc = getLocProject(project);

	debugger(total_loc);
    
	moderate_loc = sum([getLocFile(x) | x <- values["moderate"]]);
	debugger(moderate_loc);
	m1 = percent(moderate_loc,total_loc);
	debugger("Percent moderate risk: <m1>");
	
	high_loc = sum([getLocFile(x) | x <- values["high"]]);
	debugger(high_loc);
	m2 = percent(high_loc,total_loc);
	debugger("Percent high risk: <m2>");
	
	vhigh_loc = sum([getLocFile(x) | x <- values["veryhigh"]]);
	debugger(vhigh_loc);
	m4 = percent(vhigh_loc,total_loc);
	debugger("Percent very high risk: <m4>");
	/*
	++	25% 0% 0%
	+ 30% 5% 0%
	o 40% 10% 0%
	- 50% 15% 5%
	*/
	if (m1 <= 25 && m2 == 0 && m4 == 0) {
		debugger("++");
	} else if (m1 <= 30 && m2 <= 5 && m4 == 0) {
		debugger("+");
	} else if (m1 <= 40 && m2 <= 10 && m4 == 0) {
		debugger("0");
	} else if (m1 <= 50 && m2 <= 15 && m3 <= 5) {
		debugger("-");
	} else {
		debugger("--");
	}
}

public void riskCC() {

	map[str, list[loc]] values = (
		"without": [],
		"moderate": [],
		"high": [],
		"veryhigh": []);
   	
   	
   	for (f <- getFiles(project)) {
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
   		
    //debugger("CC values: <values>");   
    debugger([[x, size(values[x])] | x <- values]);
    debugger("These methods have a very high risk: <values["veryhigh"]>");
    
    total_loc = getLocProject(project);

	debugger(total_loc);
    
	moderate_loc = sum([getLocFile(x) | x <- values["moderate"]]);
	debugger(moderate_loc);
	m1 = percent(moderate_loc,total_loc);
	debugger("Percent moderate risk: <m1>");
	
	high_loc = sum([getLocFile(x) | x <- values["high"]]);
	debugger(high_loc);
	m2 = percent(high_loc,total_loc);
	debugger("Percent high risk: <m2>");
	
	vhigh_loc = sum([getLocFile(x) | x <- values["veryhigh"]]);
	debugger(vhigh_loc);
	m4 = percent(vhigh_loc,total_loc);
	debugger("Percent very high risk: <m4>");
	/*
	++	25% 0% 0%
	+ 30% 5% 0%
	o 40% 10% 0%
	- 50% 15% 5%
	*/
	if (m1 <= 25 && m2 == 0 && m4 == 0) {
		debugger("++");
	} else if (m1 <= 30 && m2 <= 5 && m4 == 0) {
		debugger("+");
	} else if (m1 <= 40 && m2 <= 10 && m4 == 0) {
		debugger("0");
	} else if (m1 <= 50 && m2 <= 15 && m4 <= 5) {
		debugger("-");
	} else {
		debugger("--");
	}
}
