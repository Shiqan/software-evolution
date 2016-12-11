@contributor{Ferron Saan - 10386831}

module main

import IO;
import String;
import Map;
import List;
import Set;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::csv::IO;
import Type;

import common;
import duplicate;
import metrics;

public loc file_vectors = |project://series2/src/vectors.csv|;
public loc file_cosines = |project://series2/src/cosine.csv|;
public loc file_euclidean = |project://series2/src/euclidean.csv|;
public loc export_file = |project://series2/src/export.json|;
//public loc src_file = |project://series2/src/export_src.csv|;
public loc src_file = |project://series2/src/export_src.json|;

public int cosine_threshold = 1;
public int euclidean_threshold = 0;

public real cosine(list[int] a, list[int] b) {
	int numerator = sum([i.first * i.second | i <- zip(a,b)]);	
	real denominator = sqrt(sum([ai*ai | ai <- a])*sum([bi*bi | bi <- b]));
	real result = numerator / denominator;	
	
	//debugger(result);
	return result;
}

public real euclidean(list[int] a, list[int] b) {
	real result = sqrt(sum([pow((i.first - i.second), 2) | i <- zip(a,b)]));
	
	//debugger(result);
	return result;	
}

public void main() {
	model = createM3FromEclipseProject(project);
	list[tuple[loc method, list[int] vector]] vectors = [];
	// vector [lines, loc, comments, params, variables, cc]
	
	int i = 1, total = size(methods(model));
	for (method <- methods(model)) {
		print("Method file <i> of <total>\r");
		
		lines = getLines(method);
		lines2 = filterLines(lines);
		
		if (lines == []) continue;
		if (lines2 == []) continue;
				
		v = [];
		v += [size(lines)];
		v += [size(lines2)];
		v += [size(lines) - size(lines2)];
		v += [params(lines2[0].line)];
		v += [variables(lines2)];
		v += [cyclomaticComplexity(lines2)];
		
		vectors += [<method, v>];
		
		i += 1;
	}	
	
	writeCSV(vectors, file_vectors);
}

public void cosine_scores() {	
	//cosines = [<a, b, cosine(vectors[a],vectors[b])> | a <- vectors, b <- vectors, a != b];
	
	vectors = readCSV(#lrel[loc method, list[int] vector], file_vectors);
	
	int i = 1, total = size(vectors);
	result = [];
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
	
	writeCSV(result, file_cosines);
}


public void euclidean_scores() {	
	
	vectors = readCSV(#lrel[loc method, list[int] vector], file_vectors);
	
	int i = 1, total = size(vectors);
	result = [];
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
	
	writeCSV(result, file_euclidean);
}

public map[str file, int methods] methods_per_file() {
	
	map[str file, int methods] x = ();
	
	model = createM3FromEclipseProject(project);
	
	for (method <- methods(model)) {	
		//debugger(method);
			
		file = extractFile(method);
		if (file in x) {
			x[file] += 1;
		} else {
			x[file] = 1;
		}
	}
	
	return x;
}

public void code_per_method() {
		
	model = createM3FromEclipseProject(project);
	
	list[tuple[str method, list[str] source]] x = [];
	
	for (method <- methods(model)) {	
		methodsrc = getLines(method);
		methodsrc = [replaceAll(s, "\t", "    ") | s <- methodsrc];
		methodsrc = [replaceAll(s, "\'", "") | s <- methodsrc];
		methodsrc = [replaceAll(s, "\<br\>", "\n") | s <- methodsrc];
		methodsrc = [replaceAll(s, "\<", " ") | s <- methodsrc];
		methodsrc = [replaceAll(s, "\>", " ") | s <- methodsrc];
		
		//x[method.path] = methodsrc;
		x += [<method.path, methodsrc>];
		
	}
	
	//writeCSV(x, src_file);
	
	writeFile(src_file, "");
	
	appendToFile(src_file, "[");
	
	int counter = 1, total = size(x);
	for (i <- x) {
		appendToFile(src_file, "{");
		appendToFileEnc(src_file, "utf-8", "\"method\":\"<i.method>\",\"source\":<i.source>");
		
		if (counter < total) {
			appendToFile(src_file, "},\n");
		} else {
			appendToFile(src_file, "}");
		}
		
		counter += 1;	
	}
	
	appendToFile(src_file, "]");
	
	debugger("-- DONE");
}

public void dups_per_file() {

	x = methods_per_file();
	y = code_per_method();
	dups = cosine_dup();
	
	list[tuple[str name, int size, list[str] imports, list[tuple[str method1, str method2]] methods]] export = [];

	for (f <- x) {
		debugger(f);
		
		imports1 = [extractFile(d.method2) | d <- dups, extractFile(d.method1) == f];
		imports2 = [extractFile(d.method1) | d <- dups, extractFile(d.method2) == f];
		imports = imports1 + imports2;
		debugger(imports);
		

		list[tuple[str method1, str method2]] methods1 = [<d.method1.path, d.method2.path> | d <- dups, extractFile(d.method1) == f];
		list[tuple[str method1, str method2]] methods2 = [<d.method2.path, d.method1.path> | d <- dups, extractFile(d.method2) == f];
		debugger(methods1);
		debugger(methods2);
		list[tuple[str method1, str method2]] methods3 = methods1 + methods2;
		debugger(methods3);
		
		export += [<f, x[f], imports, methods3>];
	}
	
	//debugger(export);
	
	writeFile(export_file, "");
	
	appendToFile(export_file, "[");
	
	int counter = 1, total = size(export);
	for (i <- export) {
		appendToFile(export_file, "{");
		appendToFile(export_file, "\"name\":\"<i.name>\",\"size\":<i.size>,\"imports\":[");
		
		int counter1 = 1, total1 = size(i.imports);
		for (j <- i.imports) {
			appendToFile(export_file, "\"<j>\"");
			
			if (counter1 < total1) {
				appendToFile(export_file, ",");
			}			
			counter1 += 1;
		}
		appendToFile(export_file, "], \"methods\":[");
		
		int counter2 = 1, total2 = size(i.methods);
		for (j <- i.methods) {
			appendToFile(export_file, "[\"<j.method1>\",\"<j.method2>\"]");
			
			if (counter2 < total2) {
				appendToFile(export_file, ",");
			}			
			counter2 += 1;
		}
		
		appendToFile(export_file, "]");
		
		if (counter < total) {
			appendToFile(export_file, "},\n");
		} else {
			appendToFile(export_file, "}");
		}
		
		counter += 1;
	}
	
	appendToFile(export_file, "]");	
	
	debugger("-- DONE");

}

public list[tuple[loc method1, loc method2, str score]] cosine_dup() {	
		
	vectors = readCSV(#lrel[loc method1, loc method2, str score], file_cosines);
	
	list[tuple[loc method1, loc method2, str score]] dups = [a | a <- vectors, toReal(a.score) >= cosine_threshold ];
	
	//debugger(size(vectors));
	//debugger(size(dups));
	
	return dups;
	
}

public void find_clone_classes() {
	vectors = readCSV(#lrel[loc method, list[int] vector], file_vectors);
	debugger(typeOf(vectors));
	
	map[list[int], list[loc]] clone_class = ();
	
	for (v <- vectors) {
		if (v.vector in clone_class) {
			clone_class[v.vector] += [v.method];
		} else {
			clone_class[v.vector] = [v.method];
		}
	}
	
	int max_clone = 0;
	for (c <- clone_class) {
		if (max_clone < size(clone_class[c])) max_clone = size(clone_class[c]);
	}
	
	debugger(max_clone);
	
	debugger([clone_class[c] | c <- clone_class, size(clone_class[c]) == max_clone]);
}

public void find_biggest_clone() {
	list[tuple[loc method1, loc method2, str score]] dups = cosine_dup();
	source = readCSV(#lrel[str method, list[str] s], |project://series2/src/export_src.csv|);
	
	list[str] max_clone = [];
		
	for (i <- dups) {
		for (j <- source) {
			if (i.method1.path == j.method) {
				if (size(max_clone) < size(j.s)) max_clone = j.s;
			}
		}
	}
	
	debugger(max_clone);
	
	
}

public void find_clone_perc() {
	list[tuple[loc method1, loc method2, str score]] dups = cosine_dup();
	source = readCSV(#lrel[str method, list[str] s], |project://series2/src/export_src.csv|);
	
	result = 0;
		
	for (i <- dups) {
		for (j <- source) {
			if (i.method1.path == j.method) {
				result += size(j.s);
			}
		}
	}
	
	debugger(getLocProject(project));
	debugger(result);
	
	
}
