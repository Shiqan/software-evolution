@contributor{Ferron Saan - 10386831}

module scores

import IO;
import String;
import List;

import common;
import cc;

public void init() {

	map[str, list[loc]] values = (
		"low": [],
		"medium": [],
		"high": [],
		"veryhigh": []);
   	
   	
   	for (f <- getFiles(project)) {
   		lrel[int cc, loc method] result = getCC(f);
   		   		
   		for (r <- result) {
   			if (r[0] <= 10) {
		    	values["low"] += [r[1]];
		    } else if (r[0]  <= 20) {
		      	values["medium"] += [r[1]];
		    } else if (r[0]  <= 50) {
		      	values["high"] += [r[1]];
		    } else {
		      	values["veryhigh"] += [r[1]];
	    	}
   		}
   		
   		
   	}
   	
	//result = [*getCC(f) | f <- getFiles(project)];	
	//debugger(result);
 // 	result = sort(result, bool (<int a, loc _>, <int b, loc _>) { return a < b; });
 // 	debugger("\n\n\n");
 // 	debugger(head(reverse(result), 10));
 //   
    debugger("CC values: <values>");   

}
