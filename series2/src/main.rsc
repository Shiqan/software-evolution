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
import duplication;
import metrics;




public void main() {
	write_vectors();
	write_cosine_scores();
	dups_per_file();
	
	code_per_method();
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

public list[tuple[str name, int size, list[str] imports, list[tuple[str method1, str method2]] methods]] dups_per_file() {

	x = methods_per_file();
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
	return export;
}

public void write_dups() {
	list[tuple[str name, int size, list[str] imports, list[tuple[str method1, str method2]] methods]] export = dups_per_file();
	
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
	
	writeCSV(x, src_file_csv);
	
	writeFile(src_file_json, "");
	
	appendToFile(src_file_json, "[");
	
	int counter = 1, total = size(x);
	for (i <- x) {
		appendToFile(src_file_json, "{");
		appendToFileEnc(src_file_json, "utf-8", "\"method\":\"<i.method>\",\"source\":<i.source>");
		
		if (counter < total) {
			appendToFile(src_file_json, "},\n");
		} else {
			appendToFile(src_file_json, "}");
		}
		
		counter += 1;	
	}
	
	appendToFile(src_file_json, "]");
	
	debugger("-- DONE");
}



public list[loc] find_clone_classes() {
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
	
	list[loc] max_clone = [];
	for (c <- clone_class) {
		if (size(max_clone) < size(clone_class[c])) max_clone = clone_class[c];
	}
	
	debugger(size(max_clone));
	
	return max_clone;
}

public list[str] find_biggest_clone() {
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
	
	return max_clone;
}

public int find_clone_perc() {
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
		
	return percent(result, getLocProject(project));
}
