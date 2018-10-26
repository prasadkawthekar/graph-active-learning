# Graph Active Learning
Code to reproduce results for B.Sc. thesis- [A2S2: A Fast Graph Active Learning Algorithm with Guarantees](bit.ly/pk_a2s2).

## Code Overview

The entry point is [code/main.m](code/main.m), which compares the query complexity for active learning algorithms S^2, BFS and A2S2 on various datasets. 
The [data/](data/) subdirectory contains the datasets used for the evaluation.

The three active learning algorithms presented follow a Wander-Focus template, which is implemented in [{algorithm}_active_learning.m](code/a2s2_active_learning.m). The algorithms differ in the Focus phase, which is implemented in [{algorithm}_focus.m](code/a2s2_focus.m).

The code additionally contains some helper functions.


## Requirements
  * [MATLAB](https://www.mathworks.com/products/matlab.html)
  * [Bioinformatics Toolbox](https://www.mathworks.com/help/bioinfo/index.html?s_tid=srchtitle)
  
This code has been run with MATLAB R2017b and R2018a; other versions may work, but have not been tested.


