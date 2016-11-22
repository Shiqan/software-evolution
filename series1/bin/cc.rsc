@contributor{Ferron Saan - 10386831}

module cc

import IO;
import String;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::\syntax::Java15;
import List;
import Exception;
import ParseTree;
import util::FileSystem;
import lang::java::\syntax::Disambiguate;
import common;

@doc{Get cyclomatic complexity of each method in a file}
public lrel[int cc, loc method] getCC(loc location) {
	lrel[int cc, loc method] result = maxCC(location);
	return result;
}

@doc{Get the CC of a method. (http://www.rascal-mpl.org/#_Metrics) }
public int cyclomaticComplexity(MethodDec m) {
  result = 1;
  visit (m) {
    case (Stm)`do <Stm _> while (<Expr _>);`: result += 1;
    case (Stm)`while (<Expr _>) <Stm _>`: result += 1;
    case (Stm)`if (<Expr _>) <Stm _>`: result +=1;
    case (Stm)`if (<Expr _>) <Stm _> else <Stm _>`: result +=1;
    case (Stm)`for (<{Expr ","}* _>; <Expr? _>; <{Expr ","}*_>) <Stm _>` : result += 1;
    case (Stm)`for (<LocalVarDec _> ; <Expr? e> ; <{Expr ","}* _>) <Stm _>`: result += 1;
    case (Stm)`for (<FormalParam _> : <Expr _>) <Stm _>` : result += 1;
    case (Stm)`switch (<Expr _> ) <SwitchBlock _>`: result += 1;
    case (SwitchLabel)`case <Expr _> :` : result += 1;
    case (CatchClause)`catch (<FormalParam _>) <Block _>` : result += 1;
  }
  return result;
}


lrel[int cc, loc method] findComplexFiles(loc project, int limit = 10) {
  result = [*maxCC(f) | /file(f) <- crawl(project), f.extension == "java"];	
  result = sort(result, bool (<int a, loc _>, <int b, loc _>) { return a < b; });
  return head(reverse(result), limit);
}


set[MethodDec] allMethods(loc file) = {m | /MethodDec m := parse(#start[CompilationUnit], file)};

lrel[int cc, loc method] maxCC(loc file) = [<cyclomaticComplexity(m), m@\loc> | m <- allMethods(file)];

