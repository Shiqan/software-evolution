@contributor{Ferron Saan - 10386831}

module duplication


import IO;
import String;
import List;
import util::Math;
import lang::csv::IO;

import common;

public list[tuple[loc method1, loc method2, str score]] cosine_dup() {	
		
	vectors = readCSV(#lrel[loc method1, loc method2, str score], file_cosines);
	
	list[tuple[loc method1, loc method2, str score]] dups = [a | a <- vectors, toReal(a.score) >= cosine_threshold ];
	
	//debugger(size(vectors));
	//debugger(size(dups));
	
	return dups;
	
}

public list[tuple[loc method1, loc method2, str score]] euclidean_dup() {	
		
	vectors = readCSV(#lrel[loc method1, loc method2, str score], file_euclidean);
	
	list[tuple[loc method1, loc method2, str score]] dups = [a | a <- vectors, toReal(a.score) <= euclidean_threshold ];
	
	//debugger(size(vectors));
	//debugger(size(dups));
	
	return dups;
	
}