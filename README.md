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
Get the loc for all methods.

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
...

# References

Davy Landman, Alexander Serebrenik, and Jurgen Vinju.  Empirical anal-ysis of the relationship between cc and sloc in a large corpus of java meth-ods.  InSoftware Maintenance and Evolution (ICSME), 2014 IEEE Inter-national Conference on, pages 221–230. IEEE, 2014.

Bruntink, M., & Van Deursen, A. (2004, September). Predicting class testability using object-oriented metrics. In Source Code Analysis and Manipulation, 2004. Fourth IEEE International Workshop on (pp. 136-145). IEEE.
