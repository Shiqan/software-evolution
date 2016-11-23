@contributor{Ferron Saan - 10386831}

module export

import IO;
import String;
import List;
import Map;
import util::FileSystem;

bool ex = true;

public loc export_file_unitsize = |project://series1/src/export_unitsize.json|;
public loc export_file_cc = |project://series1/src/export_cc.json|;
public loc export_file_duplication = |project://series1/src/export_duplication.json|;

public list[str] risks = ["without", "moderate", "high", "veryhigh"];

public void export_duplication(map[list[str], list[loc]] x) {
	if (ex) export_map2(export_file_duplication, "duplication", x);
} 

public void export_unitsize(map[str, list[loc]] x) {
	if (ex) export_map(export_file_unitsize, "unit_size", x);
}

public void export_cc(map[str, list[loc]] x) {
	if (ex) export_map(export_file_cc, "complexity", x);
}

@doc{Export a map with risk: [methods] to json}
public void export_map(loc f, str name, map[str, list[loc]] x) {
	writeFile(f, "");
	
	appendToFile(f, "{\"<name>\" : {");
	
	int counter1 = 1;
	
	for (r <- risks) {
		int counter = 1;
		appendToFile(f, "\"methods_<r>\" : [");
		for (a <- x[r]) {
			appendToFile(f, "\"<a>\"");
	
			if (counter != size(x[r])) {
				appendToFile(f, ",");
			}
			appendToFile(f, "\n");
			counter += 1;
		}
		appendToFile(f, "]");
		
		if (counter1 != size(risks)) {
			appendToFile(f, ",");
		}
		counter1 += 1;
	}
	
	appendToFile(f, "} }");	
}


@doc{Export a map with [strings]: [location] to json}
public void export_map2(loc f, str name, map[list[str], list[loc]] x) {
	writeFile(f, "");
	
	appendToFile(f, "{\"<name>\" : {");
	
	int counter = 1;
	
	for (r <- x) {
		int counter1 = 1;
		appendToFile(f, "\"<toString(r)>\": [");
		for (l <- x[r]) {
			appendToFile(f, "\"<l>\"");
			if (counter1 != size(x[r])) {
				appendToFile(f, ",");
			}
			counter1 +=1;
		}
		appendToFile(f, "]");
	
		if (counter != size(x)) {
			appendToFile(f, ",");
		}
		appendToFile(f, "\n");
		counter += 1;
	}
	
	appendToFile(f, "}");	
}
