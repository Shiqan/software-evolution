@contributor{Ferron Saan - 10386831}

module scores

import IO;
import String;
import Map;
import List;
import Set;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::csv::IO;
import util::Math;

import common;
import metrics;

public list[tuple[loc method1, loc method2, real score]] get_cosine_scores() {	
	//cosines = [<a, b, cosine(vectors[a],vectors[b])> | a <- vectors, b <- vectors, a != b];
	
	vectors = readCSV(#lrel[loc method, list[int] vector], file_vectors);
	
	int i = 1, total = size(vectors);
	list[tuple[loc method1, loc method2, real score]] result = [];
	list[tuple[loc method, list[int] vector]] vectors2 = vectors;
	for (a <- vectors) {
		print("Calculating cosine similarity <i> of <total>\r");
		
		// Transitivity
		if (size([r | r <- result, round(r[2], .001) == 1, r[0] == a.method || r[1] == a.method]) >= 1) {
			vectors2 = drop(1, vectors2);
			i += 1;
			continue;
		} 		
		
		for (b <- vectors2) {
			if (a.method == b.method) continue;
			
			c = cosine(a.vector,b.vector);
			result += [<a.method, b.method, c>]; 
		}
			
		// Symmetry
		vectors2 = drop(1, vectors2);
		
		i += 1;
	}

	//debugger(result);
	debugger(size(result));
	debugger(size(vectors));	
	
	return result;
}

public void write_cosine_scores() {
	result = get_cosine_scores();
	writeCSV(result, file_cosines);
}


public list[tuple[loc method1, loc method2, real score]] get_euclidean_scores() {	
	
	vectors = readCSV(#lrel[loc method, list[int] vector], file_vectors);
	
	int i = 1, total = size(vectors);
	list[tuple[loc method1, loc method2, real score]] result = [];
	list[tuple[loc method, list[int] vector]] vectors2 = vectors;
	for (a <- vectors) {
		print("Calculating euclidian distance <i> of <total>\r");
		
		// Transitivity
		if (size([r | r <- result, round(r[2], .001) == 0, r[0] == a.method || r[1] == a.method]) >= 1) {
			vectors2 = drop(1, vectors2);
			i += 1;
			continue;
		} 		
		
		for (b <- vectors2) {
			if (a.method == b.method) continue;
			
			c = euclidean(a.vector,b.vector);
			result += [<a.method, b.method, c>]; 
		}
			
		// Symmetry
		vectors2 = drop(1, vectors2);
		
		i += 1;
	}

	//debugger(result);
	debugger(size(result));
	debugger(size(vectors));	
	
	return result;
}

public void write_euclidean_scores() {
	result = get_euclidean_scores();
	writeCSV(result, file_euclidean);
}