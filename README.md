# syrk-verilog
Implementation of Polybench code for Symmetric Rank k in Verilog


Inputs:

• α, β: scalars

• A: N × N matrix

• C: N × N symmetric matrix

Output: Cout: N × N matrix, where Cout = αAAT + βC

Note that the output Cout is to be stored in place of the input array C. The matrix C is stored as a
triangular matrix in BLAS, and the result is also triangular. The configuration used are TRANS = ‘N’ and
UPLO = ‘L’ meaning the A matrix is not transposed, and C matrix stores the symmetric matrix as lower
triangular matrix.


Matrix size limit: 100 x 100


IPs used (Xilinx):
1) Block Memory Generator (8.2):

        • Memory Type: True Dual Port RAM
        • Memory Width: 32, Depth: 10000

2) Multiplier (12.0): 

        • Multiplier Type: Parallel Multiplier
        • Data Type: Signed
        • Width: 32 
        • Construction: Mults
        • Pipeline: 6 stages
        
3) Adder/Subtractor (12.0):

        • Implemented using: DSP48
        • Input type: Signed
        • Input width: 32
        • Add mode: Add
        • Output Width: 32


Post Synthesis performance report:

    • Frequency: 105.33 MHz
    • LUTs: 490
    • FFs 341
    • BRAMs: 9.5
    • DSP Slices: 8
    • Power: 0.125W
    
Post Implementation performance report:

    • Frequency: 121.53 MHz
    • LUTs: 460
    • FFs 428
    • BRAMs: 19
    • DSP Slices: 13
    • Power: 0.129W
