# software-evolution

# Series 1
Scores for project |project://smallsql/src|:  
--- Unit Size: --  
--- LOC: ++  
--- Duplication: -  
--- Complexity: --  
--- Test Coverage: --  

Start analyzing at: $2016-11-24T11:32:01.840+00:00$    
Scores for project |project://hsqldb-2.3.1/hsqldb/src|:  
--- Unit Size: --  
--- LOC: +  
--- Duplication: ++  
--- Complexity: --  
--- Test Coverage: --  
Finished analyzing at: $2016-11-24T11:38:40.934+00:00$  

### Unit size:
Determine loc of each method and divide over veryhigh, high, moderate and without risk. 

### LOC
Get the loc for a project and calculate the KLOC.
In order to determine the loc I remove all single and multiline comments, strip all spaces and tabs, and remove all empty and single bracket lines. Also, I do not take the tests file into consideration because it is not clear if test code influences maintainability. This is also done by Landman et al. (2014).

### Duplication
Create a map with list[str] : list[loc], where the key are lineblocks (n = 6) and the location are the files where this block occured.
Then simply get the all list[loc]'s > 1 to see how many duplicate blocks there are.

### Complexity
Used the method on the rascal homepage. Simply + 1 for each other path in the tree of a method.

### Test coverage
Currently I just get the number of methods in test file and calculate the percentage of total methods in the project. 
Getting the methods in test files is questionable already because I only check for junit or test in the name... But even if this was the perfect way to get the numbers of methods in test files this metric does not make much sense. E.g. a test method can cover multiple methods etc etc.

A much better way is to check the ease of which a test can be written, such as looking if all variables declared in a file or class 
are used within that file or class. This is also proposed (along with other metrics for testability) by Bruntik and van Deursen (2004). 



# Series 2
### Metric based approach
1. For each method, calcuate the following metrics to create a vector: Number of Lines, Lines of Code, Lines with comments, number of parameters, number of variables and cyclomatic complexity.
I chose these metrics based on research from Roy et al. (2009), Baxter et al. (1998), Antoniol et al. (2001) and Mayrand (1996).
However, these studies use more metrics. 
2. For all method combinations, calcuate the cosine similarity based on the two vectors.
3. Find all the scores where the cosine similarity equals 1 (same vector). When adding more metrics to the vectors this threshold needs to be adjusted.

### Visualization
For the visualization of the clones I chose to implement an edge bundle diagram described in Hauptmann et al. (2012) and Zhou et al. (2013). This way, it is easy to see how clones are related within files and focus on manual inspection of the clones. Since this is on file level, I added an onclick event to show which methods exactly are the clones and when clicking a table row you can actually see the source code of both methods. Therefore, my visualization supports root cause analysis.

# References
Roy, C. K., Cordy, J. R., & Koschke, R. (2009). Comparison and evaluation of code clone detection techniques and tools: A qualitative approach. Science of Computer Programming, 74(7), 470-495.

Baxter, I. D., Yahin, A., Moura, L., Sant'Anna, M., & Bier, L. (1998, November). Clone detection using abstract syntax trees. In Software Maintenance, 1998. Proceedings., International Conference on (pp. 368-377). IEEE.

Antoniol, G., Penta, M. D., Casazza, G., & Merlo, E. (2001, November). Modeling clones evolution through time series. In Proceedings of the IEEE International Conference on Software Maintenance (ICSM'01) (p. 273). IEEE Computer Society.

Mayrand, J., Leblanc, C., & Merlo, E. M. (1996, November). Experiment on the automatic detection of function clones in a software system using metrics. In Software Maintenance 1996, Proceedings., International Conference on (pp. 244-253). IEEE.

Hauptmann, B., Bauer, V., & Junker, M. (2012, June). Using edge bundle views for clone visualization. In Proceedings of the 6th International Workshop on Software Clones (pp. 86-87). IEEE Press.

Zhou, H., Xu, P., Yuan, X., & Qu, H. (2013). Edge bundling in information visualization. Tsinghua Science and Technology, 18(2), 145-156.

Davy Landman, Alexander Serebrenik, and Jurgen Vinju.  Empirical anal-ysis of the relationship between cc and sloc in a large corpus of java meth-ods.  InSoftware Maintenance and Evolution (ICSME), 2014 IEEE Inter-national Conference on, pages 221–230. IEEE, 2014.

Bruntink, M., & Van Deursen, A. (2004, September). Predicting class testability using object-oriented metrics. In Source Code Analysis and Manipulation, 2004. Fourth IEEE International Workshop on (pp. 136-145). IEEE.
